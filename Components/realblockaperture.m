%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [particles,trajectories] = realblockaperture(particles,trajectories,param,radius,width,height)
%% function definition 
%This instrument represents the almagamation of 2 previous instruments-
%this is done by just making single instrument that passes to these 2
% instruments 1 by 1
%% code
[particles,trajectories] = blockaperture(particles,trajectories,param,radius); %circle part
[particles,trajectories] = rectangularblockaperture(particles,trajectories,param,width,height); %wire part
end