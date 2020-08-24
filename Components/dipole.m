function [particles,trajectories] = dipole(particles,trajectories,param,entrytransition)
%% function definition
%this is a weak dipole function which acts as a sudden transtion such that
%spin states are projected into the basis given by the field direction (in
%this case along ny)
%the function does the following: 

%if the entry transition is sudden, it
%takes the old field direction, new field direction and subsequently
%rotates the spins between frames.

%if the entry transition is smooth, it does nothing, (the spin states
%remain fixed relative to the new field)


% I NEED TO MAKE SURE THAT I GET THE RELATIVE TRANSITIONS RIGHT HERE- LETS
% THINK ABOUT TRANSITIONS BETWEEN FRAMES THAT AREN'T ALIGNED WITH THE LAB
% FRAME.
%% code
for i = 1:numel(particles) %convert to component frame
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end

if strcmp('sudden', entrytransition) %if the entry transition is sudden
    for i = 1:numel(particles)
        particles(i).spin = suddenspintransition(particles(i).Bfield,cross(param(2,:),param(3,:)),particles(i).spin);
        %The spins are rotated from the old field to the new field where
        %both the old and new fields are expressed with lab frame unit
        %vectors. The old field is found from the particles structure and
        %the new field is the ny direction of the dipole
    end
end

% any code related to the form of the dipole goes here

for i = 1:numel(particles)
    particles(i).Bfield = cross(param(2,:),param(3,:)); %the new b field is saved as the ny direction of the dipole
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end