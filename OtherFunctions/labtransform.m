function [newV,newr] = labtransform(v,r,param)
%% FUNCTION DEFINITION
%the following function converts position and velocity vectors back from the instrument frame to the lab
%frame given that nx and nz are the instrument frame unit vectors.
%the form of the parameters matrix is [origin;nz,nx]
%% code

xprime = param(3,:);
yprime = cross(param(2,:),param(3,:));
zprime = param(2,:);
R = [xprime',yprime',zprime'];

newV = (R*(v'))';
newr = param(1,:) + (R*(r'))';
%spin;
%newspin = (Rspin*(spin'))';
%newr = (r(1)*param(3,:) +r(2)*ny + r(3)*param(2,:))+param(1,:);
end