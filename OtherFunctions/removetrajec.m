function [newparticles, newtrajectories] = removetrajec(particles,trajectories,rlimit,block)
%% FUNCTION DEFINITION
%this function finds the particles and corresponding trajectories for
%particles that are less than a distance rlimit from the instrument axis,it
%then creates new particles and trajectories structures, adds them and then
%returns these back
%a value of block corresponding to 1 indicates a blocking aperture, and 0
%indicates a normal aperture.
%% code
rm= zeros(1,numel(particles));
%define an empty list of 0s which is the same length as the particles structure
for i = 1:(numel(particles))
    %Check if the particle lies in the correct region for each
    %aperture(both blocking and not blocking)
    %if it does then set the corresponding value in the rm matrix to
    %the number particle that matches the condition
    r = sqrt(dot((particles(i).position),(particles(i).position)));
    if block == 0
        if r<rlimit
            rm(i) = i;
        end
    elseif block == 1
        if r>rlimit
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
newtrajectories = repmat(struct('position',zeros(100,3),'spin',zeros(100,2),'Numberofentries',1),N,1);
for i = 1:N
    %copy across the data corresponding to the particles which passed the
    %check
    newparticles(i) = particles(rm(i));
    newtrajectories(i) = trajectories(rm(i));
end
end