function [Eref_0] = quasi_stat_dielec_cons(Er_0,u)
a=1+ (1/49)*log((u^4+(u/52)^2)/(u^4+0.432)) + (1/18.7)*log(1+(u/18.1)^3);
b=0.564 * ((Er_0-.9)/(Er_0+3))^0.053;
Eref_0=(Er_0+1)/2 + ((Er_0-1)/2)*(1+10/u)^(a*b);