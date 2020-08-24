function [newV,newpos] = frametransform(v, r, param)
%% FUNCTION DEFINITION
%this funciton takes a velocity V and a position r and translates them to a new reference
%frame with 2 coordinate axis specified by nx and nz as on figure1.1 in
%the manual
%The velocity is just found by making a vector made up of components in
%each direction
%The position is found by subtracting the origin away from the lab position
%and then resolving into the required directions in the same way as
%velocity

%% code

xprime = param(3,:);
yprime = cross(param(2,:),param(3,:));
zprime = param(2,:);

R = [xprime',yprime',zprime'];

newpos = (R'*(r'-(param(1,:)')))';
newV = (R'*(v'))';
%spin;
%newspin = (Rspin'*(spin'))';

%ny = cross(param(2,:),param(3,:));

%vxt = dot(v,param(3,:));
%vyt = dot(v,ny);
%vzt = dot(v,param(2,:));

%rn = r-param(1,:);
%rxt = dot(rn,param(3,:));
%ryt = dot(rn,ny);
%rzt = dot(rn,param(2,:));

%newpos = [rxt ryt rzt];
%newV = [vxt vyt vzt];
end