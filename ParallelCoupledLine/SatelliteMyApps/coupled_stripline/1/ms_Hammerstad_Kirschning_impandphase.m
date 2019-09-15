function [Z_0_f, eps_eff_f] = ms_Hammerstad_Kirschning(w, t, h, eps_r, f_vec)
%[Z_0_f, eps_eff_f] = ...
%       ms_Hammerstad_Kirschning(width, thickness, height, eps_r, f_vec)
% Calculate the Line impedance of a microstrip line with the model of
% Hammerstad and Jensen from 1980 including the stripthickness correction.
% The frequency dispersion is modelled with the model of Jansen and
% Kirschning.

%CONSTANTS
eps_0 = 8.854187817620e-12;
mu_0  = 4*pi*1.0e-7;
c0 = 1/sqrt(eps_0*mu_0);
eta_0 = sqrt(mu_0/eps_0);

u=w/h;
%%%%  Strip thickness correction %%%%
T = t/h; %normalized strip thickness
if T>0
%/* (6) from Hammerstad and Jensen */
deltaul = (T/pi)*log(1.0 + 4.0*exp(1.0)/(T*(coth(sqrt(6.517*u)))^2));
%/* (7) from Hammerstad and Jensen */
deltaur = 0.5*(1.0 + 1.0/cosh(sqrt(eps_r-1.0)))*deltaul;
elseif T==0
    deltaul=0;
    deltaur=0;
else
    error('Negative Stripdicke!')
end
ul = u + deltaul;
ur = u + deltaur;

%%%% CALCULATION of corrected LINEIMPEDANCE for f=0 %%%%
[Z_ur, eps_ur]=ms_Hammerstad_thin_metal_1980(ur*h,h,eps_r);
[Z_ul, eps_ul]=ms_Hammerstad_thin_metal_1980(ul*h,h,eps_r);
% % (8) from Hammerstad and Jensen
Z_0_f0=Z_ur/sqrt(eps_ur);
% % (9) from Hammerstad and Jensen
eps_eff_f0=eps_ur*(Z_ul/Z_ur)^2;

%%%% CALCULATION OF DISPERSION ACCORDING TO JANSEN %%%%

%%%% effective permittivity dispersion (Kirschning/Jansen )%%%%
fn = 1e-7 * f_vec * h; % normalized frequency (GHz-cm)
P1 = 0.27488 + (0.6315 + 0.525 ./ (1.0 + 0.157*fn).^20.0 )*u - 0.065683*exp(-8.7513*u);
P2 = 0.33622*(1.0 - exp(-0.03442*eps_r));
P3 = 0.0363*exp(-4.6*u)*(1.0 - exp(-(fn/3.87).^4.97));
P4 = 1.0 + 2.751*( 1.0 -  exp(-(eps_r/15.916)^8.0));
P = P1*P2.*((0.1844 + P3*P4)*10.0.*fn).^1.5763;
% /* (1) from Kirschning and Jansen */
eps_eff_f = (eps_eff_f0 + eps_r*P)./(1.0 + P);

%%%% Characteristic Impedance (Jansen/Kirschning) %%%%
fn = 1.0e-6 * f_vec * h; % normalized frequency (GHz-mm)
%    /* (1) from Jansen and Kirschning */
R1 = min(0.03891*eps_r^1.4,20);
R2 = min(0.267*u^7.0,20);
R3 = 4.766*exp(-3.228*u^0.641);
R4 = 0.016 + (0.0514*eps_r)^4.524;
R5 = (fn/28.843).^12.0;
R6 = min(22.20*u^1.92,20);
%    /* (2) from Jansen and Kirschning */
R7 = 1.206 - 0.3144*exp(-R1)*(1.0 - exp(-R2));
R8 = 1.0 + 1.275*(1.0 - exp(-0.004625*R3*eps_r^1.674*(fn/18.365).^2.745));
R9 = 5.086*R4*R5/(0.3838 + 0.386*R4).*exp(-R6)./(1.0 + 1.2992*R5)* (eps_r-1.0)^6.0/(1.0 + 10.0*(eps_r-1)^6.0);
%    /* (3) from Jansen and Kirschning */
R10 = 0.00044*eps_r^2.136 + 0.0184;
R11 = (fn/19.47).^6.0./(1.0 + 0.0962*(fn/19.47).^6.0);
R12 = 1.0 / (1.0 + 0.00245*u*u);
%    /* (4) from Jansen and Kirschning */
R13 = 0.9408*eps_eff_f.^R8 - 0.9603;
R14 = (0.9408 - R9).*eps_eff_f0.^R8-0.9603;
R15 = 0.707*R10*(fn/12.3).^1.097;
R16 = 1.0 + 0.0503*eps_r*eps_r*R11.*(1.0 - exp(-(u/15)^6.0));
R17 = R7*(1.0 - 1.1241*(R12./R16).*exp(-0.026*fn.^1.15656-R15));
%    /* (5) from Jansen and Kirschning */
Z_0_f = Z_0_f0*(R13./R14).^R17;

end


function [Z_0_0, eps_eff_0]=ms_Hammerstad_thin_metal_1980(w,h,eps_r)

eps_0 = 8.854187817620e-12;
mu_0  = 4*pi*1.0e-7;

u = w/h; %normalized strip width

% (4) from Hammerstad and Jensen
A = 1.0 + (1.0/49.0)*log((u^4.0 + (u/52.0)^2.0)/...
    (u^4.0 + 0.432))+ (1.0/18.7)*log(1.0 + (u/18.1)^3.0);

% (5) from Hammerstad and Jensen */
B = 0.564*((eps_r-0.9)/(eps_r+3.0))^0.053;

% zero frequency effective permitivity.  (3) from Hammerstad and Jensen.  
% This is ee(ur,eps_r) thats used by (9) in Hammerstad and Jensen.
eps_eff_0 = (eps_r+1.0)/2.0 + ((eps_r-1.0)/2.0)*(1.0 + 10.0/u)^(-A*B);

% (2) from Hammerstad and Jensen.  'u' is the normalized width */
F = 6+(2*pi-6)*exp(-(30.666/u)^0.7528);
% (1) from Hammerstad and Jensen */
eta_0 = sqrt(mu_0/eps_0);
Z_0_0 = eta_0/(2*pi)*log(F/u+sqrt(1+(2/u)^2));

end
