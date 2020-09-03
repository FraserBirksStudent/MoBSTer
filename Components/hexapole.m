function [newparticles,newtrajectories] = hexapole(particles,trajectories,param,radius,length,fieldstrength)
%% FUNCTION DEFINITION
%The form of the param matrix is [origin;nz;nx]
%The function must do the following things, in order.
%-An aperture function at the start of the hexapole
%-Convert all the particles into the component frame
%-The next section of code is a for loop which generates 4 matrices (x,y,z
%and t) with each column being the trajectory a particle took. The initial
%conditions are specified as y(1) = y, y(2) = vy, y(3) = x, y(4) = vx
%-Propagate the particles through the hexapole with the differential
%equation solver
%-Solving the timestep issue: A major problem with this model is that if
%each trajectory is propagated for a fixed number of timesteps, they will
%all end up at vastly different points. To solve this, my solution is to
%find a number of timesteps for each particle by doing the
%length divided by the particles initial z velocity. As the vz component
%doesnt change, this should lead to all particles finishing at the same
%point (at the second aperture).
%-Convert the particles back to the lab frame
%-Add the matrix columns of the propagation of each particle to the
%trajectory vector in the lab frame.

%hexapole spin direction is a big issue: The transition is smooth, meaning
%that the eigenstate coefficients do not need to be changed as the atoms
%move from the lab frame into the hexapole frame. However, upon exit from
%the hexapole (and dipole) the spin states have the given coefficents but
%in the direction of +-y in the lab frame, so the spin transformation
%vector needs to reflect this- to do this, just have the Rspin be generated
%based on the dipole field z direction which is the hexapole ny = nzXnx -
%granted this is a botch temporarily
%% CODE
%ENTRANCE SPIN TRANSITION IS SMOOTH, so spin does not need to be
%transformed as calpha and cbeta remain fixed relative to the new field
%directions
NumericalStepWidth = 40e-3; %change the numerical step width that the hexapole uses to solve equations- by default 40e-3.From testing
%changing this value only makes a difference on the order of 10s nanometers
%to the beam after it leaves the hexapole, but having it too low results in
%nasty looking hexapole trajectories
stepno = round(length/NumericalStepWidth);%
[particles,trajectories] = aperture(particles,trajectories,param,radius); %the entry aperture.
t = zeros(stepno+1,2*numel(particles));
pos = cell(stepno+1,2*numel(particles));
vel = cell(stepno+1,2*numel(particles));
%create new structures twice the size which will hold all the new
%trajectories and particles
newparticles = repmat(struct('position',zeros(1,3),'velocity',zeros(1,3),'spin',zeros(1,2),'weight',1,'time',0,'Bfield',zeros(1,3)), numel(particles)*2, 1 );
newtrajectories = repmat(struct('position',zeros(100,3),'Numberofentries',1),numel(particles)*2,1);
%oldlabspin = particles(100).spin;
for i = 1:numel(particles) %convert to component frame
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end
%oldinstrspin = particles(100).spin;
% i am going to arbitratily say that it is the alpha spin state (first
% number) that is focused and the beta spin state(second number) that is
% de-focused
opts = odeset('RelTol',1e-2); %this is the error tolerance- in practice changing this only causes deviations on the sub nanometre scale
%By default it is set to 1%
for i = 1:numel(particles)%propagates each particle in turn and creates the x, y, z matrices
    %first line just makes new trajectories match the old trajectories
    %(with duplicates every other trajectory)
    newtrajectories((2*i-1):(2*i)) = [trajectories(i),trajectories(i)];
    newparticles((2*i-1):(2*i)) = [particles(i),particles(i)];
    %assign each of the focusing and de-focusing trajectories the correct
    %spin states using the projection operator. Then assign them the
    %correct weights using the dot product that vector with itself.
    totaltime = length/particles(i).velocity(1,3);
    
    newparticles(2*i-1).spin = ([0 0;0 1]*(particles(i).spin)')';
    newparticles(2*i-1).weight = dot(newparticles(2*i-1).spin,newparticles(2*i-1).spin);
    newparticles(2*i).spin = ([1 0;0 0]*(particles(i).spin)')';
    newparticles(2*i).weight = dot(newparticles(2*i).spin,newparticles(2*i).spin);
    newparticles(2*i-1).time = newparticles(2*i-1).time+totaltime;
    newparticles(2*i).time = newparticles(2*i-1).time+totaltime;
    
    k = -1;%solve differential equation for each particle
    [tv1, Yv1] = ode23(@(t,Y) cartesianhexapole(t,Y,k,fieldstrength,radius), [0:totaltime/stepno:totaltime], [particles(i).position(2),particles(i).velocity(2),particles(i).position(1),particles(i).velocity(1)],opts);
    k = 1;
    [tv2, Yv2] = ode23(@(t,Y) cartesianhexapole(t,Y,k,fieldstrength,radius), [0:totaltime/stepno:totaltime], [particles(i).position(2),particles(i).velocity(2),particles(i).position(1),particles(i).velocity(1)],opts);
    %CREATE A 3d matrix with the top layer being x, the second layer being
    %y and the third layer being z, and same with velocity.
    pos(:,(2*i-1)) = mat2cell([Yv1(:,3),Yv1(:,1),tv1*particles(i).velocity(3)],ones(1,stepno+1));
    pos(:,(2*i)) = mat2cell([Yv2(:,3),Yv2(:,1),tv2*particles(i).velocity(3)],ones(1,stepno+1));
    vel(:,(2*i-1)) = mat2cell([Yv1(:,4),Yv1(:,2),ones(stepno+1,1)*particles(i).velocity(3)],ones(1,stepno+1));
    vel(:,(2*i)) = mat2cell([Yv2(:,4),Yv2(:,2),ones(stepno+1,1)*particles(i).velocity(3)],ones(1,stepno+1));
end
%next section goes through and sets the new position and velocity of each
%particle in the component frame
for i = 1:numel(newparticles)
    newparticles(i).velocity = cell2mat(vel(stepno+1,i));
    newparticles(i).position = cell2mat(pos(stepno+1,i));
end
%Newparticles is then transformed into the lab frame - such that those
%which are 
%newinstrspin = newparticles(100).spin;

%EXIT PARTICLE SPIN remains polarised within local fields, and is meaningless until passed through a dipole


for i = 1:numel(newparticles)
    newparticles(i).Bfield = [NaN NaN NaN];
    [newparticles(i).velocity,newparticles(i).position] = labtransform(newparticles(i).velocity,newparticles(i).position,param);
end
%newlabspin = newparticles(100).spin;
%this part is by far the longest in the section after solving the
%differential equations- it takes 2 and a half seconds for 2500 particles

%must now add all positions to the trajectories structure. To do this,
%First must translate the pos vector to the lab frame using the rotation
%matrix (=[x',y',z'])
xprime = param(3,:);
yprime = cross(param(2,:),param(3,:));
zprime = param(2,:);
R = [xprime',yprime',zprime'];
labpos = cellfun(@(M)(param(1,:)+(R*M')'),pos,'UniformOutput',false);
%now, add each cell in the labpos function to the trajectories structure

for i = 1:numel(newparticles)
    N = newtrajectories(i).Numberofentries;
    newtrajectories(i).Numberofentries = N+stepno+1;
    newtrajectories(i).position(N+1:N+stepno+1,:) = cell2mat(labpos(:,i));
end

%at the end of the hexapole is the next aperture. parameters of next aperture must be defined, (nx and nz the
%same, but origin shifted by l*nz)
param2 = [param(1,:)+(param(2,:)*length);param(2,:);param(3,:)];
 
%next aperture function called with new particles and trajectories
[newparticles,newtrajectories] = aperture(newparticles,newtrajectories,param2,radius);

%NOTE, THE SPINS THAT THE HEXAPOLE RETURNS ARE ONLY POLARISED WITH RESPECT
%TO EACH LOCAL Z AXIS. AS THE EXIT IS A SMOOTH TRANSITION, WHATEVER THE NEXT INSTRUMENT
%IS WILL INITIALLY HAVE A SMOOTH TRANSITION TO BE ALIGNED WITH WHATEVER
%FIELD IS PROMINANT.
end

