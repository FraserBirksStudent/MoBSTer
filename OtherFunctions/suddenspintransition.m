%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function newspin = suddenspintransition(oldB,newB,spin)
%% function definition
%This function takes two magnetic field vectors in the same frame as input
%arguments, transforms to the reference frame where the old field is along
%Z and generates a spin rotation matrix based on the angles
%between them- the spin vector is essentially rotated the in the opposite
%as if the field is fixed along z.

%The 2 normal vectors, denoted oldB and newB, are taken and
%first transformed into the Spin Frame. The Spin Frame is a reference
%frame where oldB points along Z, with spiny defined as
%cross(spinz,labx) normalised, and spinx defined as cross(spiny,spinz).
%(refer to the sudden spin transition section of the manual to see exactly
%where these definitions come from)
%In this way, the definition of the spin x and y axis are kept consistent
%relative to the lab frame.

%the angle theta between the oldB and newB is found, and the normal vector
%to both these field directions which the rotation that takes place is
%defined by, which is an xy plane vector. This angle is then broken up into its phix and phiy
%components, which are then used to generate the resultant rotation matrix
%which acts on the spin. (they are made negative as in the frame of the
%field the spin rotates backward)

% the reason that this is done every single time is so this function can be
% generalised when multiple particles are propagating through a numerical
% field- each particle will have its own 'old field' direction.
%% code
oldB = oldB./sqrt(dot(oldB,oldB));
newB = newB./sqrt(dot(newB,newB));%normalise oldB and newB

%express spinz,spinx and spiny in terms of field frame unit vectors
spinz = oldB;
if spinz == [1 0 0]
    spinx = cross([0 1 0],spinz);
    spinx = spinx./(sqrt(dot(spinx,spinx)));
    spiny = cross(spinz,spinx);
else
    spiny = cross(spinz,[1 0 0]);
    spiny = spiny./(sqrt(dot(spiny,spiny)));
    spinx = cross(spiny,spinz);
end
Rspinframe = [spinx',spiny',spinz']; %create rotation matrix to convert fields to spin frame
oldBSF = (Rspinframe'*(oldB)')';
newBSF = (Rspinframe'*(newB)')';
%Convert old field directions to spin frame

n = cross(oldBSF,newBSF);
theta = acos(dot(newBSF,oldBSF));
phix = -theta*n(1);
phiy = -theta*n(2);

Rx = [cos(phix/2) -1i*sin(phix/2); -1i*sin(phix/2) cos(phix/2)];
Ry = [cos(phiy/2) -sin(phiy/2); sin(phiy/2) cos(phiy/2)];

Rspin = Rx*Ry; %generate spin rotation matrix in spin frame
newspin = (Rspin*spin')';%Find the new spin!
end