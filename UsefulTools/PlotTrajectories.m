%% copyright notice
% Copyright (c) 2020, Fraser Birks and William Allison.
% All rights reserved.
% This file is part of MoBSTer - a framework to simulate Molecular Beam Scattering Using Trajectories, subject to the GNU/GPL-3.0-or-later.
%% function definition
%This is just a tool that is pre built to let you plot trajectories (like
%the section of the UI but easier to edit- for example if you want to take
%a better look at a section of the journey and not just see the entire
%thing.)

%initialise the x,y and z vectors for each trajectory
x = zeros(1,trajectories(1).Numberofentries-20);
y = zeros(1,trajectories(1).Numberofentries-20);
z = zeros(1,trajectories(1).Numberofentries-20);

figure
hold on
grid on
%define the number of trajectories to plot up to 1000
if numel(trajectories)<1000
    num = numel(trajectories);
else
    num = 1000;
end
%Get the particle paths taken for every particle
for i = 1:num
    for p = 20:trajectories(i).Numberofentries
        x(p-19) = trajectories(i).position(p,1);
        y(p-19) = -trajectories(i).position(p,2);
        z(p-19) = trajectories(i).position(p,3);
    end
    %Plot the trajectory
    plot3(z,y,x)
end
%Set the section of each plot you want to look at.
ylim([1.585 1.595])
xlim([0.395 0.405])
xlabel(['z'])
ylabel(['-y'])
zlabel(['x'])
