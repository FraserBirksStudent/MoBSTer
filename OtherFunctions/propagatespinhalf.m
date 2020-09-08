function newspin = propagatespinhalf(oldspin,gmr,B,t)
%% function definition
%This function takes the time spent in a field, calculates the
%correspoinding spin rotation operator using [exp(-i*phi/2) 0; 0
%exp(i*phi.2)] where phi = -gmr*B*t
phi = -gmr*B*t;
spinop = [exp(-i*(phi/2)) 0; 0 exp(i*(phi/2))];
newspin = (spinop*(oldspin)')';