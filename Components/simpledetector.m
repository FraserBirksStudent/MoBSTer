%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [particles,trajectories] = simpledetector(particles,trajectories,param,radius)
%% function definition
% for now, this simple detector function is simply a black hole aperture.
% It is assumed that all particles passed through the aperture are
% detected. This could be improved by implementing a detector which has the
% properties of the true detector in the spin echo machine

%% code
[particles,trajectories] = aperture(particles,trajectories,param,radius);
end