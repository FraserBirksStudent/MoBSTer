%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.

function [particles,trajectories] = simplesourcev2(N, param, Radius, zspacing, beamenergy)
%% Function definition:
%this function is a much faster version of the previous simple source
%function as it uses pre-initialised arrays and structures and does not
%rely heavily on for loops
%
%this entirely works within the lab frame- as rand points returns
%coordinates in the lab frame
%
%This source is an OBVIOUS APPROXIMATION and therefore should NOT be used
%for simulations where accurate data is needed readily.
%
%It is essentially two circles seperated by a distance zspacing. points are
%generated on each of the two circles that are connected to form a straight
%line. These then form the trajectories.
%
% The particle beam is generated with the following parameters:
% A velocity distribution given by a gaussian with FWHM 1/10 of the
% velocity given by the beam energy.

% Randomly genereted spin vectors, generated by creating 2 complex numbers
% with magnitude 1 in totally random directions, and then normalising these
% spin vectors such that they satisfy the spin condition that
% mod(calpha)^2 + mod(cbeta)^2 = 1

%% IMPORTANT ASSUMPTION
%Another assumption is made to save memory when initialsing the
%trajectories vector, that being that the trajectories of each particle will be fully
%described by 100 points connected by straight lines. Of course, it could go over this number
%And all this would result in is dynamic resizing which would dramatically reduce runtime
%If you know that you are going to store more than 100 data points for each
%particle then increase this number (though you will have to also increase
%it within other functions that re-initialise the trajectory array, like
%the removetrajec.m functions and the hexapole function)


%% Code
Aperture1 = param;
r2 = param(1,:) - zspacing*param(2,:);
Aperture2 = [r2;param(2,:);param(3,:)];

points2 = RandPoints(N,Aperture1,Radius);
points1 = RandPoints(N,Aperture2,Radius);


vavg = sqrt((2*beamenergy*(10^-3)*1.6e-19)/(1.66*3*(10^-27)));%calculate average molecule velocity based on energy

%If the user wants to change the width of the distribution of the velocity, they need to
%change the 10 in the below line.
vdist = vavg + ((vavg/10)/2.355)*randn(N,1); %calculate velocity distribution using FWHM = vavg/10

%Calculate the prefactors matrix, which is for each particle is just the
%velocity given by the distribution above multiplied by a normalising
%factor.
prefactors = vdist.*sqrt((1./(((points2(:,1)-points1(:,1)).^2)+((points2(:,2)-points1(:,2)).^2)+((points2(:,3)-points1(:,3)).^2))));

%Generate velocity matrix.
v = prefactors(:,1).*[points2(:,1)-points1(:,1) points2(:,2)-points1(:,2) points2(:,3)-points1(:,3)];

%generate inital z spin eigenstate coeffiecients, which are of the form
%[Calpha Cbeta] these have the property that mod(calpha)^2 + mod(cbeta)^2 =
%1
theta = rand(N,2)*2*pi;
unnormalised = cos(theta)+1i*sin(theta);
numbers = rand(N,1);
normfactors = [sqrt(numbers), sqrt(1-numbers)];
spinvector = normfactors.*unnormalised;

%store the initial postions in the trajectory structure and all the initial
%information in the particle structure

particles = repmat(struct('position',zeros(1,3),'velocity',zeros(1,3),'spin',zeros(1,2),'weight',1,'time',0,'Bfield',[0 0 1]), N, 1 );
trajectories = repmat(struct('position',zeros(100,3),'Numberofentries',1),N,1);
for int = 1:N
    %Add all the initial data to the particles structure.
    particles(int).position = points2(int,:);
    particles(int).velocity = v(int,:);
    particles(int).spin = spinvector(int,:);
    trajectories(int).position(1,:) = points2(int,:);
end
end


