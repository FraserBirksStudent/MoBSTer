%% Summary:
%This is a program that calculates a spin-echo curve (using the
%cambridge machine setup) 

%A quick note- it only takes spin echo curve of the true polarisation after
%the analyser

%If one wants to see the process needed to plot measured polarisation plots
%and spin echo curves using the calibration solenoid, see the
%'CambridgeMachineTransmissionAnalysisExample.m'

%%
clear all
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 1000;
%initialise to get the parameters vector and the component structure
[parameters,component] = initialisecambridge();

%% for loop to iterate over different solenoid field strengths

pvector = zeros(601,1);
%initialise vector that will store true polarisation information for each
%run and iterate over 600 different field strengths - which ar the same in
%both solenoids
for fieldstep = -300:300
    
    fieldstep
    
    solenoidfield = 1e-6*(fieldstep); %increases each time
    
    % run the whole simulation
    [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);

    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),component(2).radius,component(2).length,component(2).fieldstrength);
    
    %[particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,3),component(3).gaussparam);
    
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,4),component(4).entrytype);
    
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,5),component(5).radius,component(5).length,component(5).GyroMagneticRatio,solenoidfield,component(5).entrytype);
    
    [particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,6));
    
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,7),component(7).radius,component(7).length,component(7).GyroMagneticRatio,solenoidfield,component(7).entrytype);
    
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,8),component(8).entrytype);
    
    %[particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,9),component(9).gaussparam);
    
    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,10),component(10).radius,component(10).length,component(10).fieldstrength);
    
    %calculate polarisation at end of run
    alphaweight = 0;
    betaweight = 0;
    for int = 1:numel(particles)
        if particles(int).spin(1,1) == 0
            betaweight = betaweight + particles(int).weight; %calculate the weight of the defocused particles
        else
            alphaweight = alphaweight + particles(int).weight; %calculate the weight of the focused particles
        end
    end
    pvector(fieldstep+301) = (alphaweight-betaweight)/(alphaweight+betaweight);  %calculate the polarisation using these weights
    
end
%plot result
Bfield = [-300e-6:1e-6:300e-6]
plot(Bfield,pvector)
xlabel(['Solenoid B field (T)'])
ylabel(['Normalised beam polarisation'])