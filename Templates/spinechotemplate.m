%% Summary:
%This is a template for a spin-echo curve investigation
%It begins by initialising the parameters
%%
clear 
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 1000
%initialise to get the parameters vector and the component structure
[parameters,component] = initialise()

%% for loop to iterate over different solenoid field strengths
%define the number of steps, and the Pvector and Wvector that represent
%total weight.
stepno = 600
pvector = zeros(stepno,1)
wvector = zeros(stepno,1)
for fieldstep = (-stepno/2):(stepno/2)
    
    solenoidfield = 2e-6*(fieldstep); %increases each time
    
    %Just change all the '-' values to the corresponding component number
    %for each instrument. Add and remove instruments where necessary - to
    %match your machine set-up
    
    %Source
    [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);
    %Hexapole1
    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).fieldstrength);
    %Dipole1
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,-),component(-).entrytype);
    %Calibration solenoid
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).GyroMagneticRatio,component(-).fieldstrength,component(-).entrytype);
    %Solenoid 1
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).GyroMagneticRatio,component(-).fieldstrength,component(-).entrytype);
    %Sample
    [particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,-))
    %Solenoid 2
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).GyroMagneticRatio,component(-).fieldstrength,component(-).entrytype);
    %Dipole2
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,-),component(-).entrytype);
    %Hexapole 2    
    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).fieldstrength);
    
    %Calculation of true polarisation at end of run - a detector is not
    %necessary to know this.
    
    alphaweight = 0; 
    betaweight = 0;
    for int = 1:numel(particles)
        if particles(int).spin(1,1) == 0
            betaweight = betaweight + particles(int).weight;
            %calculate the total spin down particle weight and the total spin up particle weight
        else
            alphaweight = alphaweight + particles(int).weight;
        end
    end
    %Calculate the total polarisation and save it to the pvector
    pvector(fieldstep+(stepno/2)+1) = (alphaweight-betaweight)/(alphaweight+betaweight);
    
    %Detector
    [particles,trajectories] = aperture(particles,trajectories,parameters(:,:,-),component(-).radius);
    
    Tweight = 0;
    for int = 1:numel(particles) %Measure the total weight.
        Tweight = particles(int).weight +Tweight;
    end
    wvector(fieldstep+(stepno/2)+1) = Tweight;
    
    %If you would like to measure polarisation accurately- each
    %measurement of the 
end
%plot results
figure
Bfield = [-600e-6:2e-6:600e-6]
plot(Bfield,pvector)
xlabel(['Solenoid B field (T)'])
ylabel(['True beam polarisation'])
title(['True beam polarisation spin echo curve'])

figure
plot(Bfield,wvector)
xlabel(['Solenoid B field (T)'])
ylabel(['Total weight detected'])
title(['Total weight detected spin echo curve'])