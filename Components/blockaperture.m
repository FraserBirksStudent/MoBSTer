%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [particles, trajectories] = blockaperture(particles,trajectories,param,radius)
%% FUNCTION DEFINITION
%This is assumed to be an infinitely thin aperture, and does the following:
%-Transforms the particle positions and velocities to the aperture frame via
%the transform function
%propagates all the particle trajectories in a straight line until they
%have a z position of 0
%-calls the remove trajectory function with the block argument = 1 and removes any particles inside the radius of the aperture. 
%The particles which pass through are added to the trajectory vector using the
%addtotrajectories function
%The particles are then converted back into the lab frame
%% Code

for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end
particles = propagate(particles);
[particles, trajectories] = removetrajec(particles,trajectories,radius,1);
trajectories = addtotrajectories(particles,trajectories,param);
for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end
end