%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [newparticles, newtrajectories] = removetrajecrectangle(particles,trajectories,width,height,block)
%% FUNCTION DEFINITION
%this function finds the particles and corresponding trajectories for
%particles that are either within(seethrough) or not within(blocking)
%the specified width and height from the instrument axis,it
%then creates new particles and trajectories structures, adds them and then
%returns these back
%% code
rm= zeros(1,numel(particles)); %define an empty list of 0s which is the same length as the particles structure
for i = 1:(numel(particles))
    %Check if the particle lies in the correct region for each aperture,
    %and if it does then set the corresponding value in the rm matrix to
    %the number particle that matches the condition
    if abs(particles(i).position(1))<(width/2) && abs(particles(i).position(2))<(height/2)
        if block == 0
            rm(i) = i;
        end
    else
        if block == 1
            rm(i) = i;
        end
    end
end
%Remove all of the 0s from the rm vector, leaving a list of the positions
%of all the particles that pass through in the particles structure.
rm(rm==0)=[];
N = numel(rm);
%Initialise new structures for particles and trajectories
newparticles  = repmat(struct('position',zeros(1,3),'velocity',zeros(1,3),'spin',zeros(1,2),'weight',1,'time',0,'Bfield',zeros(1,3)), N, 1 );
newtrajectories = repmat(struct('position',zeros(100,3),'Numberofentries',1),N,1);
for i = 1:N
    %copy across the data corresponding to the particles which passed the
    %check
    newparticles(i) = particles(rm(i));
    newtrajectories(i) = trajectories(rm(i));
end
end