%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [particles,trajectories] = dipole(particles,trajectories,param,entrytransition)
%% function definition
%this is a dipole function which essentially just acts as a transtion such that
%spin states are defined relative to a new field direction. in the case of
%the dipoles this is given by nx it is either smooth or sudden.

%the function does the following: 

%if the entry transition is sudden, it
%takes the old field direction, new field direction and subsequently
%rotates the spins between frames.

%if the entry transition is smooth, it does nothing, (the spin states
%remain fixed relative to the new field)

%In both cases, upon exit the field that each particle is defined relative
%to is assigned to the dipole field direction.

%currently this dipole does not alter the spatial information of the
%trajectories at all, in the future it may be worth adding an aperture.
%% code
for i = 1:numel(particles) %convert to component frame
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end

if strcmp('sudden', entrytransition) %if the entry transition is sudden
    for i = 1:numel(particles)
        particles(i).spin = suddenspintransition(particles(i).Bfield,param(3,:),particles(i).spin);
        %The spins are rotated from the old field to the new field where
        %both the old and new fields are expressed with lab frame unit
        %vectors. The old field is found from the particles structure and
        %the new field is the ny direction of the dipole
    end
end

% any code related to the form of the dipole goes here

for i = 1:numel(particles)
    particles(i).Bfield = param(3,:); %the new b field is saved as the nx direction of the dipole
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end