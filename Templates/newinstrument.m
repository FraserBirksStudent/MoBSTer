function [particles,trajectories] = newinstrument(particles,trajectories,param)
%% Function Definiton

% This function is a template used for the creation of new
% instruments.

% Please refer to the 'component construction' section of the manual and the intro page in the user
% interface for help.

% The template is split into sections concerning each part of a general
% instrument- which may or may not be useful to you.

% Essential code (frame transforms) has been written for you.
% Code that may be useful has been included (but commented out)

%% Instrument entry

% This will likely be a circular or rectangular aperture (or perhaps a combination of the two). 
% Where possible, use the aperture instruments that have already been created. These
% instruments take the particle structure in the lab frame.

% [particles,trajectories] = aperture(particles,trajectories,param,radius);
% [particles,trajectories] = rectangularaperture(particles,trajectories,param,width,height)

%% Sudden spin transition

% This section is code for a sudden spin transition where particle
% spins are tranformed to the new field direction

%if strcmp('sudden', entrytransition)
    %for i = 1:numel(particles)
        %particles(i).spin = suddenspintransition(particles(i).Bfield,newfielddirection,particles(i).spin);
    %end
%end

%% Instrument frame velocity and position conversion

% This section is required in every instrument- Transformation of the
% particle position and velocity to the instrument frame.

for i = 1:numel(particles) %convert to component frame
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end

%% Instrument function

% This region is your own code which defines what the instrument does.
% See the manual for guidance on how to update the data structures.

%% Lab frame velocity and position conversion

% This section is required in every instrument- Transformation of the
% particle position and velocity to the lab frame.

% An optional extra line of code exists here which is to update the field
% direction the spin is defined relative to- for instruments containing a
% magnetic field that have a smooth or sudden transition.

for i = 1:numel(particles) 
    %particles(i).Bfield = newfielddirection;  %optional extra line
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end

%% Instrument exit
% This will again likely be a circular or rectangular aperture (or perhaps a combination of the two). 
% Where possible, use the aperture instruments that have already been created. These
% instruments take the particle structure in the lab frame.

% As this aperture is at the end of your instrument you must update the
% aperture origin in the lab frame. This is done below if your instrument
% is straight with a defined length.

%param2 = [param(1,:)+(param(2,:)*length);param(2,:);param(3,:)]; %calculate the parameters of the aperture at the end
%[particles,trajectories] = aperture(particles,trajectories,param2,radius);
%[particles,trajectories] = rectangularaperture(particles,trajectories,param2,width,height)

end

