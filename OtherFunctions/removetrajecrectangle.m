function [newparticles, newtrajectories] = removetrajecrectangle(particles,trajectories,width,length,block)
%% FUNCTION DEFINITION
%this function finds the particles and corresponding trajectories for
%particles that are either within(seethrough) or not within(blocking)
%the specified width and height from the instrument axis,it
%then creates new particles and trajectories structures, adds them and then
%returns these back
%% code
rm= zeros(1,numel(particles));
for i = 1:(numel(particles))
    if abs(particles(i).position(1))<(width/2) && abs(particles(i).position(2))<(length/2)
        if block == 0
            rm(i) = i;
        end
    else
        if block == 1
            rm(i) = i;
        end
    end
end
rm(rm==0)=[];
N = numel(rm);

newparticles  = repmat(struct('position',zeros(1,3),'velocity',zeros(1,3),'spin',zeros(1,2),'weight',1,'time',0,'Bfield',zeros(1,3)), N, 1 );
newtrajectories = repmat(struct('position',zeros(100,3),'Numberofentries',1),N,1);
for i = 1:N
    newparticles(i) = particles(rm(i));
    newtrajectories(i) = trajectories(rm(i));
end
end