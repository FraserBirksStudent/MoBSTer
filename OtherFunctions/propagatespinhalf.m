%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function newspin = propagatespinhalf(oldspin,gmr,B,t)
%% function definition
%This function takes the time spent in a field, calculates the
%correspoinding spin rotation operator using [exp(-i*phi/2) 0; 0
%exp(i*phi.2)] where phi = -gmr*B*t
phi = -gmr*B*t;
spinop = [exp(-i*(phi/2)) 0; 0 exp(i*(phi/2))];
newspin = (spinop*(oldspin)')';