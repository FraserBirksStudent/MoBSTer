function [particles,trajectories] = hexapoledipoletransition(particles,trajectories,param,gaussparam)
%% function definition
%This is just an instrument that has the simple job of adding a random
%variable to edit the phase of each and every trajectory, based on
%velocity.
%First, a vector of velocity magnitudes is generated from the particles
%structure
%Then, a vector of theta values is generated from a gaussian random
%variable that uses a mean which is (a*v + b) and a std of c
%Next, a vector of random 2pi values is generated- and then used to create
%a vector of nx and ny vales.
%Next, this vector of nx and ny is converted into a vector of thetax and
%thetay values
%Finally, a for loop where each spin vector gets operated on by the
%corresponding rotation matrix is completed, with each rotation matrix
%being generated as the first step of the for loop

[a, b, c] = gaussparam
N = numel(particles);
v = vertcat(particles(:).velocity);
modv = (v(:,1).^2 + v(:,2).^2 + v(:,3).^2).^(0.5);
theta = randn(N,1)*c + (a*modv + b);
phi = rand(N,1)*2*pi;
n = [cos(phi) sin(phi)];
thetaxy = theta.*n;
for int = 1:N
    R = [cos(thetaxy(int,1)/2) -j*sin(thetaxy(int,1)/2); -j*sin(thetaxy(int,1)/2) cos(thetaxy(int,1)/2)]*[cos(thetaxy(int,2)/2) -sin(thetaxy(int,2)/2); sin(thetaxy(int,2)/2) cos(thetaxy(int,2)/2)];
    particles(int).spin = (R*(particles(int).spin)')';
end