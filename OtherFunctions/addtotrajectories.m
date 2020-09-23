%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function trajectories = addtotrajectories(particles,trajectories,param) 
%This function takes the current position of all particles in the component frame, converts them
%into the lab frame and adds them to the trajectory list. This is usually
%called right after the trajectories and particles corresponding to
%trajectories that have left the instrument have been removed from the
%structures.


for i = 1:numel(particles)
    [~,pos] = labtransform(particles(i).velocity,particles(i).position,param);
    trajectories(i).position(((trajectories(i).Numberofentries)+1),:) = pos;
    trajectories(i).Numberofentries = trajectories(i).Numberofentries + 1;
end
end