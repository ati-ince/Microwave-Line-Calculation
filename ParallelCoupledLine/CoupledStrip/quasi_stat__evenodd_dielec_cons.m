function [Eref_e_0,Eref_o_0] = quasi_stat__evenodd_dielec_cons(Er_0,Eref_0,u,g)
%
v=(u*(20+g^2))/(u+g^2) + g*exp(-g);
ae=1+ (1/49)*log((v^4+(v/52)^2)/(v^4+0.432)) + (1/18.7)*log(1+(v/18.1)^3);
be=0.564 * ((Er_0-.9)/(Er_0+3))^0.053;
%
Eref_e_0=(Er_0+1)/2 + ((Er_0-1)/2)*(1+10/v)^(ae*be);
%%
ao = .7287*(Eref_0-.5*(Er_0+1))*(1-exp(-.179*u));
bo=  (.747*Er_0)/(.15+Er_0);
co=bo-(bo-.207)*exp(.414*u);
do=.593+.694*exp(-.562*u);
%
Eref_o_0=(  .5*(Er_0+1)+ ao + Eref_0 )*exp(-co*(g.^do))+Eref_0;