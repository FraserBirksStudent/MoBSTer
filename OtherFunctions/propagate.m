%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function particles = propagate(particles)
%% Function Definition
%This function propagates all particles forwards until the z component = 0
%(that is, they sit in the origin plane of the instrument). It then returns
%the particle vector.
%it does this by getting the z coordinate of each particle, making it
%positive and then dividing it by the z velocity to find the time taken to
%travel. It then adds this to the time component of each particle and uses
%this new time to work out how far it's moved in x and y, and makes sure to
%update these positions also.
%% code
for i = 1:numel(particles)
    t = (-particles(i).position(1,3))/(particles(i).velocity(1,3));
    particles(i).time = particles(i).time + t;
    particles(i).position = particles(i).position + t*(particles(i).velocity);
end
end