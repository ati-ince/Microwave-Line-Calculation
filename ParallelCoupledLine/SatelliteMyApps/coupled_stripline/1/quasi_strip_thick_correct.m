function [delta_W1,delta_Wr] = quasi_strip_thick_correct(W_0,t,h,pi,Er_0)
delta_W1= (t/(h*pi))*log(1+ ((4*exp(1))/((t/h)* (coth(sqrt(6.517*W_0)))^2 ) ));
delta_Wr=.5*delta_W1*(1+sech(sqrt(Er_0-1)));