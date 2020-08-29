function newspin = suddenspintransition(oldB,newB,spin)
%% function definition
%This function takes two magnetic field vectors in the same frame as input
%arguments, and generates a spin rotation matrix based on the angles
%between them- the spin vector is essentially rotated the in the opposite
%direction if the field remains in the same frame.

%This matrix is then used to rotate the spinor vector, which is then
%returned by this function.
%this is done by taking the 2 normal vectors, denoted oldB and newB, and
%first transforming them into the Spin Frame. The Spin Frame is a reference
%frame where oldB points along spinz, with spiny defined as
%cross(spinz,labx) normalised, and spinx defined as cross(spiny,spinz).
%In this way, the definition of the spin x and y axis are kept consistent
%relative to the lab frame- and consistent with how they are generated.

%the angle theta between the oldB and newB is found, and the normal vector
%which is an xy plane vector. This angle is then broken up into its phix and phiy
%components, which are then used to generate the resultant rotation matrix
%which acts on the spin. (they are made negative as in the frame of the
%field the spin rotates backward)

% the reason that this is done every single time is so this function can be
% generalised when multiple particles are propagating through a numerical
% field with different spin states.
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
    spiny = cross(spinz,[1 0 0])
    spiny = spiny./(sqrt(dot(spiny,spiny)))
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
phiz = -theta*n(3);%can be removed
Rx = [cos(phix/2) -i*sin(phix/2); -i*sin(phix/2) cos(phix/2)];
Ry = [cos(phiy/2) -sin(phiy/2); sin(phiy/2) cos(phiy/2)];
Rz = [exp(-i*(phiz/2)) 0; 0 exp(i*(phiz/2))];%can be removed
Rspin = Rx*Ry*Rz; %generate spin rotation matrix in spin frame
newspin = (Rspin*spin')';%Find the new spin!
end