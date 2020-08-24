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
    
    %Just change all the '-' values to the corresponding component number
    %for each instrument. Add and remove instruments where necessary
    [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);

    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).fieldstrength);
    
    [particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,-),component(-).gaussparam)
    
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,-),component(-).entrytype);
    
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).GyroMagneticRatio,component(-).fieldstrength,component(-).entrytype);
    
    [particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,-))
    
    [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).GyroMagneticRatio,component(-).fieldstrength,component(-).entrytype);
    
    [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,-),component(-).entrytype);
    
    [particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,-),component(-).gaussparam);
    
    [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,-),component(-).radius,component(-).length,component(-).fieldstrength);
    
    %calculate polarisation at end of run
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
%plot result
Bfield = [-600e-6:2e-6:600e-6]
plot(Bfield,pvector(401:1001))
xlabel(['Solenoid B field (T)'])
ylabel(['Normalised beam polarisation'])