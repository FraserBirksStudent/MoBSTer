%% Summary:
%This is a template for a spin-echo curve investigation
%It begins by initialising the parameters
%%
clear all
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 1000
%initialise to get the parameters vector and the component structure
[parameters,component] = initialise()

%% for loop to iterate over different solenoid field strengths
pvector = zeros(701,1)
for fieldstep = -300:300
    
    solenoidfield = 2e-6*(fieldstep); %increases each time
    
    
    [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),sourceradius,100e-3,beamenergy);

    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),hexapole1radius,hexapole1length,hexapole1fieldstr);
  
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,3),dipole1entrytype,dipole1exittype);
    
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,4),solenoid1radius,solenoid1length,GyroMagneticRatio,solenoid1field);
    
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,5),dipole2entrytype,dipole2exittype);
    
    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,6),hexapole2radius,hexapole2length,hexapole2fieldstr);
    
    alphaweight = 0;
    betaweight = 0;
    for int = 1:numel(particles)
        if particles(int).spin(1,1) == 0
            betaweight = betaweight + particles(int).weight;
        else
            alphaweight = alphaweight + particles(int).weight;
        end
    end
    pvector(fieldstep+701) = (alphaweight-betaweight)/(alphaweight+betaweight);
    
end
Bfield = [-600e-6:2e-6:600e-6]
plot(Bfield,pvector(401:1001))
xlabel(['Solenoid B field (T)'])
ylabel(['Normalised beam polarisation'])