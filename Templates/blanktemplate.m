%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

%% Information
%This is a blank template: You need to completely create your own code in
%the mobster framework! The initialisation step is included for you- but
%other than that you are on your own. 
%Please refer to the manual/the other templates/the examples provided for
%the exact syntax needed!
%The initialisation step is included for you

%%
clear 
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 10000
%initialise to get the parameters vector and the component structure
[parameters,component] = initialise()

%your code here! (make sure you pass the correct arguments to each
%instrument you call!)