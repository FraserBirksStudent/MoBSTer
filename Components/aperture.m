function [particles, trajectories] = aperture(particles,trajectories,param,radius)
%% FUNCTION DEFINITION
%This is assumed to be an infinitely thin aperture, and does the following:
%-Transforms the particle positions and velocities to the aperture frame via
%the transform function
%propagates all the particle trajectories in a straight line until they
%have a velocity of 0
%-calls the remove trajectory function with block argument being = 0 and removes any particles outside the radius of the aperture. 
%The particles which pass through are added to the trajectory vector using the
%it then calls the add to trajectories function to save the new spatial
%positions to the trajectories structure
%The particles are then converted back into the lab frame
%% Code
for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end
particles = propagate(particles);
[particles, trajectories] = removetrajec(particles,trajectories,radius,0);
trajectories = addtotrajectories(particles,trajectories,param);
for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end
end