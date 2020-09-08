function [particles,trajectories,runtime,Nin,Nout] = instrumenttest()
%% function definiton:
% This is a function created to produce a simple test of each instrument
% By default the instrument is placed in front of the
% source-hexapole-dipole configuration with the same layout as the start of
% the cambridge machine.

%% define instruments
n = 4; %number of components
%generate a component structure
component = repmat(struct('name',strings,'angles',zeros(1,3),'origin',zeros(1,3),'radius',0,'length',0,'fieldstrength',0,'entrytype',strings), n, 1 );
parameters = zeros(3,3,n);

%% number of particles in test
N = 10000
%% SOURCE
component(1).name = 'Source';
component(1).angles = [0 0 0]; %[ALPHA BETA GAMMA];
component(1).origin = [0 0 0];
component(1).radius = 0.25e-3;
component(1).beamenergy = 10;%meV
[nz,nx] = angletonormalvector(component(1).angles);
parameters(:,:,1) = [component(1).origin; nz; nx];

%HEXAPOLE 1
component(2).name = 'hexapole1';
component(2).angles = [0 0 0];
component(2).origin = [0 0 220e-3];
component(2).radius = 1e-3;
component(2).length = 300e-3;
component(2).fieldstrength = 1.1;
[nz,nx] = angletonormalvector(component(2).angles);
parameters(:,:,2) = [component(2).origin; nz; nx];

%DIPOLE 1
component(3).name = 'dipole1';
component(3).angles = [0 0 0];
component(3).origin = [0 0 520e-3];
component(3).entrytype = 'smooth';
[nz,nx] = angletonormalvector(component(3).angles);
parameters(:,:,3) = [component(3).origin; nz; nx];



%YOUR INSTRUMENT HERE
%component(4).name =
%component(4).angles =
%component(4).origin =
[nz,nx] = angletonormalvector(component(4).angles);
parameters(:,:,4) = [component(4).origin;nz;nx];


%% Run simulation
[particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);

[particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),component(2).radius,component(2).length,component(2).fieldstrength);
    
[particles,trajectories] = dipole(particles,trajectories,parameters(:,:,3),component(3).entrytype);

Nin = numel(particles);
tic
%YOUR INTSTRUMENT HERE
%[particles,trajectories] = YOURCOMPONENT(particles,trajectories,parameters(:,:,4),)

runtime = toc
Nout = numel(particles);
end