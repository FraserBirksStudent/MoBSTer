function newspin = suddenspintransition(oldB,newB,spin)
%% function definition
%This function takes two magnetic field vectors in the same frame as input
%arguments, and generates a spin rotation matrix based on the angles
%between them- the spin vector is essentially rotated the in the opposite
%direction if the field remains in the same frame.

%This matrix is then used to rotate the spinor vector, which is then
%returned by this function.
%this is done by taking the 2 normal vectors, denoted oldB and newB, and
%using them to find the rotation angle within the plane which contains both
%of them (theta). This angle is then broken up into its phix and phiy
%components, which are then used to generate the resultant rotation matrix
%which acts on the spin. (they are made negative as in the frame of the
%field the spin rotates backward)

% the reason that this is done every single time is so this function can be
% generalised when multiple particles are propagating through a numerical
% field with different spin states.
%% code
oldB = oldB./sqrt(dot(oldB,oldB));
newB = newB./sqrt(dot(newB,newB));%normalise oldB and newB
n = cross(oldB,newB);
theta = acos(dot(newB,oldB));
phix = -theta*n(1);
phiy = -theta*n(2);
phiz = -theta*n(3);
Rx = [cos(phix/2) -i*sin(phix/2); -i*sin(phix/2) cos(phix/2)];
Ry = [cos(phiy/2) -sin(phiy/2); sin(phiy/2) cos(phiy/2)];
Rz = [exp(-i*(phiz/2)) 0; 0 exp(i*(phiz/2))];
Rspin = Rx*Ry*Rz;
newspin = (Rspin*spin')';
end