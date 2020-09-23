%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function Pos = RandPoints(N,param,Radius)
%% Function definition:
% Chooses a number, N, random points within a circular aperture of 
% radius, Radius, in an aperture specified by the matrix Aperture.
% _________________________
% Parameters:
% Aperture is a 3x3 matrix:
%
%  * Row 1: position of the centre of the aperture, [x,y,z] / m
%  * Row 2: unit normal, gives aperutre orientation, nz
%  * Row 3: unit vector in the aperture plane, giving the azimuthal 
%         orientation, nx

%  Radius / m is the radius of the aperture
% 
%  Pos /m is an output array giving the list of row-vectors, one row per 
%  point, which is the coordinates of the point in the laboratory frame.
%
% Method:
%   We choose the point randomly in local radial coordinates 
%   $$ [\rho,\phi] $$.
%   Thus $$ \phi \in{[0,2\pi]} $$ is chosen with a uniform probability, and
%   $$ \rho $$ is chosen with $$ P(\rho)\sim \rho $$.
%   after expressing the point in local cartesian coordinates 
%   $$ [X_l, Y_l, 0] $$, the position in the laboratory plane is 
%   $$ [x, y, z] = [X_1 \hat{x}, Y_1 \hat{y}, 0] + P $$, 
%   where $P$ is the centre of the aperture (i.e. the origin of the local 
%   coordinates) and $\hat{x}$ and $\hat{y}$ are unit vectors specifying
%   the local x and y directions. Here, $\hat{y}$ is obtained from 
%   $\hat{y}=\hat{z} \times \hat{x}$
%
%   A particularly key point is that this function returns a list of random
%   points of a circle within the lab frame.
%
%% Code
% write out the local x and y unit vectors.
xhat=param(3,:);
yhat=cross(param(2,:),param(3,:));
%
phi = rand(N,1)*2*pi;    %Choose phi uniformly
% Choose distance from the centre with probability P(r) ~ r
rho = sqrt(rand(N,1))*Radius;    %N.B. sqrt() function gives P(r)dr ~ r.
%Create lists of local x=rho*cos(theta and local y=rho*sin(theta)
xlocal=rho.*cos(phi);
ylocal=rho.*sin(phi);
% Get them in the lab frame by mulripying by unit vectors and adding shift
% from the origin (given by Aperture(1,:)).
posx=[xlocal*xhat(1), xlocal*xhat(2), xlocal*xhat(3)];
posy=[ylocal*yhat(1), ylocal*yhat(2), ylocal*yhat(3)];
Pos=posx+posy;
Pos=Pos(:,:)+param(1,:);
end