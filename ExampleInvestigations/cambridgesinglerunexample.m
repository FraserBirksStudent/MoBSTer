%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

%% Information
%The following is just a single run-through of the the cambridge machine
%setup with the default instruments.
%%
clear all
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 10000;
%initialise to get the parameters vector and the component structure
[parameters,component] = initialisecambridge();

%% simulation


%% source
[particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);
%% hexapole 1
[particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),component(2).radius,component(2).length,component(2).fieldstrength);
%% dipole 1
[particles,trajectories] = dipole(particles,trajectories,parameters(:,:,4),component(4).entrytype);
%% calibration solenoid
[particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,13),component(13).radius,component(13).length,component(13).GyroMagneticRatio,component(13).fieldstrength,component(13).entrytype);
%% solenoid 1
[particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,5),component(5).radius,component(5).length,component(5).GyroMagneticRatio,component(5).fieldstrength,component(5).entrytype);
%% sample
[particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,6));
%% solenoid 2
[particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,7),component(7).radius,component(7).length,component(7).GyroMagneticRatio,component(7).fieldstrength,component(7).entrytype);
%% dipole 2
[particles,trajectories] = dipole(particles,trajectories,parameters(:,:,8),component(8).entrytype);
%% hexapole 2
[particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,10),component(10).radius,component(10).length,component(10).fieldstrength);
%% detector aperture
[particles,trajectories] = simpledetector(particles,trajectories,parameters(:,:,11),component(11).radius);%detector