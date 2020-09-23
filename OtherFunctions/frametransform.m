%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [newV,newpos] = frametransform(v, r, param)
%% FUNCTION DEFINITION
%this funciton takes a velocity V and a position r and translates them to a new reference
%frame with 2 coordinate axis specified by nx and nz as on figure1.1 in
%the manual
% A rotation matrix is generated from the directions in the lab frame -
% this is then transposed to get the matrix required to transform into the
% component frame.

%The velocity is found by directly using this rotation matrix, and the
%The position is found by subtracting the origin away from the lab position
%and then transforming into the required directions the same way as
%velocity.

%% code

xprime = param(3,:);
yprime = cross(param(2,:),param(3,:));
zprime = param(2,:);

R = [xprime',yprime',zprime'];

newpos = (R'*(r'-(param(1,:)')))';
newV = (R'*(v'))';

end