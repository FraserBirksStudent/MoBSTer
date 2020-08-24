function [particles,trajectories] = realblockaperture(particles,trajectories,param,radius,width,length)
%% function definition 
%This instrument represents the almagamation of 2 previous instruments-
%this is done by just making single instrument that passes to these 2
% instruments 1 by 1
%% code
[particles,trajectories] = blockaperture(particles,trajectories,param,radius); %circle part
[particles,trajectories] = rectangularblockaperture(particles,trajectories,param,width,length); %wire part
end