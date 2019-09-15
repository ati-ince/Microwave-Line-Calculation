%% D��ar�dan girilecekler
% Frekans,Z_0 hat empedans�, Z_L y�k empedans�
function Empedans_kayipsiz = iletim_hatti_empedans_kayipsiz(f,length_,Z_0,Z_L)
% Length = 1/2 vs gibi lamdan�n katlaridir.
% Z_in = Z_0 * ( (Z_L+ i * tan (Beta*Length_))/(Z_0+i*Z_L*tan (Beta*Length_)) );
% Lamda_ = c/f
% Beta = (2*pi)/Lamda_
% c=3*(10^8);
% f=2.4*(10^9);
% Z_0 = 50;
% %Z_L = [0 Inf]; % ac�k ve k�sa devre i�in ama bunu gorebilmek i�i 500 par�aya bolek yada ka�a istersek
% Lamda_= c/f;
% Lamda=0:(.001*Lamda_):(.5-.001)*Lamda_;%500 par�a vs..
% Beta=(2*pi)./Lamda;
% Length_ = Lamda;
% Z_L = 0:2:(1000-2); % buda 500 par�a oldu
% Z_in = Z_0.* ( (Z_L+ i * tan (Beta.*Length_))./(Z_0+i*Z_L.*tan (Beta.*Length_)) );
c=3*(10^8);
lamda_=c/f;
Beta = (2*pi)/lamda_;
Length_=length_ * lamda_;
z_L=Z_L/Z_0;
z_in = (z_L+i*tan(Beta*Length_))/(1+i*z_L*tan(Beta*Length_));
Z_in=z_in*Z_0;
Empedans_kayipsiz=Z_in;