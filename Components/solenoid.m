function [particles,trajectories] = solenoid(particles,trajectories,param,radius,length,gmr,Bstrength,entrytransition)
%% function definition
%This function represents the solenoid instrument. This function will carry
%out the following steps
%an aperture function at the start of the solenoid
%convert to the solenoid instrument frame
%for each particle, calculate time to travel the length of the solenoid
%call a function with the field strength, time and gmr and the original spin. This calculates the
% new spin and returns it.
%particles converted into the lab frame
%finally, another aperture function is called at the end.

%The first thing we have to do is calculate the time each particle spends
%in the solenoid using the assumption that each trajectory travels
%straight.

%It then calls the precess spin function for each particle with the time
%spent in the field and the particles spin states.

%The spin rotation operator is Rz(phi) = [exp[-i*phi/2] 0; 0 exp[i*phi/2]]
%the time spent in the field is equal to t = abs(pi/2*omega0) where omega0
%is the larmor frequency = -gmr*B0

%% code

[particles,trajectories] = aperture(particles,trajectories,param,radius); %the entry aperture.
%IF THIS INSTRUMENT HAS SUDDEN SPIN ENTRY- the spins must be rotated to the
%new frame
if strcmp('sudden', entrytransition)
    for i = 1:numel(particles)
        particles(i).spin = suddenspintransition(particles(i).Bfield,param(2,:),particles(i).spin);%oldfield newfield oldspin
        %The spins are rotated from the old field to the new field where
        %both the old and new fields are expressed with lab frame unit
        %vectors. The old field is found from the particles structure and
        %the new field is the ny direction of the dipole
    end
end

for i = 1:numel(particles) %convert to component frame
    [particles(i).velocity,particles(i).position] = frametransform(particles(i).velocity,particles(i).position,param);
end

for i = 1:numel(particles) %for all particles
    t = (length)/(particles(i).velocity(1,3));%calculate time to travel length of solenoid in component frame
    particles(i).spin = propagatespin(particles(i).spin,gmr,Bstrength,t);% the spin is propagated;
end

for i = 1:numel(particles) %convert to lab frame
    particles(i).Bfield = param(2,:); %define the b field the spin of each particle is defined relative to as a lab frame vector
    [particles(i).velocity,particles(i).position] = labtransform(particles(i).velocity,particles(i).position,param);
end
param2 = [param(1,:)+(param(2,:)*length);param(2,:);param(3,:)]; %calculate the parameters of the aperture at the end of the solenoid
[particles,trajectories] = aperture(particles,trajectories,param2,radius); %the exit aperture.