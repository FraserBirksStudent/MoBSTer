function [particles, trajectories] = flatsample(particles, trajectories, param)
%% function definition
%This function simulates reflection of a perfectly flat sample
%The way it does this is by - transforming into the sample frame, and
%propagating all the particles until they are at z = 0
%-all the vz components are flipped in order to simulate reflection.
%the locations of each particle is added to the trajectories vector
%-finally the particles are transformed back into the lab frame
%at the moment, the surface normal vector is defined to be the opposite to
%nz:this means alpha, beta and gamma are to align the negative normal
%vector

% this must also have a section which acts as a smooth transition to
% re-define the magnetic field the spin is defined relative to to be the
% reflection of the previous magnetic field direction in the sample
%% code
for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end
particles = propagate(particles);
for i = 1:numel(particles)
    particles(i).velocity(1,3) = -particles(i).velocity(1,3);
end
trajectories = addtotrajectories(particles,trajectories,param);
for i = 1:numel(particles)
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end
end
    