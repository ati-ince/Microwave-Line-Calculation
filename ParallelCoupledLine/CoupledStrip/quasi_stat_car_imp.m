function [Z0_0,Z01_0] = quasi_stat_car_imp(pi,Er_0,u,eta_0)
fu=6+(2*pi-6)*exp(-(30.666/u)^.7528);
Z01_0=(eta_0/(2*pi))*log(fu/u  + sqrt(1+(2/u)^2));
Z0_0=Z01_0/sqrt(Er_0);
