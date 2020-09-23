%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [nz,nx] = angletonormalvector(angles)
%% FUNCTION DEFINITION
%This function takes the following vector as a parameter 
%[alpha, beta, gamma]. It generates the correct rotation matrices and hence
%the combined rotation matrix (making sure to do the alpha rotation first)
%It then operates on the vectors in the lab frame which would correspond to
%nz and nx if no rotation occured, these being nz = [0 0 1] and 
%nx = [1 0 0] to generate the new nz and nx vectors.

%% Code
R1 = [cosd(angles(1)) sind(angles(1)) 0;-sind(angles(1)) cosd(angles(1)) 0; 0 0 1];

R2 = [cosd(angles(2)) 0 -sind(angles(2)); 0 1 0; sind(angles(2)) 0 cosd(angles(2))];

R3 = [1 0 0; 0 cosd(angles(3)) sind(angles(3)); 0 -sind(angles(3)) cosd(angles(3))];

RT = R3*R2*R1;

nz = (RT*[0 0 1]')';
nx = (RT*[1 0 0]')';
end
