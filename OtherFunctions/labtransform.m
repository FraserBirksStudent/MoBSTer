%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [newV,newr] = labtransform(v,r,param)
%% FUNCTION DEFINITION
%the following function converts position and velocity vectors back from the instrument frame to the lab
%frame given that nx and nz are the instrument frame unit vectors.
%the form of the parameters matrix is [origin;nz,nx]
%% code

%It generates the corresponding rotation matrix that does the
%transformation and then operates on the velocity and origin correctly-
%making sure to add the lab origin to the newly transformed origin.
xprime = param(3,:);
yprime = cross(param(2,:),param(3,:));
zprime = param(2,:);
R = [xprime',yprime',zprime'];

newV = (R*(v'))';
newr = param(1,:) + (R*(r'))';

end