function [particles,trajectories] = simpledetector(particles,trajectories,param,radius)
%% function definition
% for now, this simple detector function is simply a black hole aperture.
% It is assumed that all particles passed through the aperture are
% detected. This could be improved by implementing a detector which has the
% properties of the true detector in the spin echo machine

%% code
[particles,trajectories] = aperture(particles,trajectories,param,radius);
end