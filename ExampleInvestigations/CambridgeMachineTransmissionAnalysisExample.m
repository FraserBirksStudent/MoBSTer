%% information
% This example plots the transmission of the cambridge spin echo machine
% against beam energy for different aperture sizes, and with the presence
% of a blocking aperture on axis.

% It plots the measured polarisation data and the true polarisation
% data for each set. The 'true polarisation' is found by just analysing the
% spins as the particles leave the analyser, and the theoretical maximum
% polarisation that could be measured if the polariser was perfect.

%The 'measured polarisation' is found by varying the Bfield in the
%calibration solenoid over a single beam spin rotation and plotting out the
%cosine curve of total intensity. The curve fitting toolbox is then used to
%fit a cosine curve to this data, and the parameters are extracted, to find
%the beam polaristion that would be measured in the lab.

% Each cosine curve for a set up at a specific energy is plotted with 31
% datapoints, there are 8 energies per set up, and 3 set ups. This means
% that in total 744 simulations are run, each with N particles, so this
% program takes some time if N is large (>10000).

% The three set ups this is plotted for are: a 6mm detector aperture, a
% 2.4mm detector aperture, and a 2.4mm detector aperture with a realistic blocking aperture
% on axis at the start of the analyser
%% code
clear 
close all
%NUMBER OF PARTICLES GENERATED
tic
N = 1000;
%initialise to get the parameters vector and the component structure
[parameters,component] = initialisecambridge();
gamma = abs(component(13).GyroMagneticRatio); %pull the gyromagnetic ratio from the components structure
esteps = 8; 
%the number of energy steps
Pvector = zeros(esteps,1);
Wvector = zeros(31,esteps,3);
sfields = zeros(31,esteps,3);
%initialise all the vectors that will store simulation data.
component(11).radius = 3e-3;
%set the first run detector radius
for sets = 1:3
    sets
    if sets == 2
        component(11).radius = 1.2e-3 % on second run set to 2.4mm
    end
    for energystep = 1:esteps
        energystep
        component(1).beamenergy = 5+(5*(energystep-1)); %update the beam energy each energystep
        %calculate each individual field step, working backward from the solution to the
        %schrodinger equation for spin-1/2 propgation in the calibration
        %solenoid such that the spin varies over about a 3.5pi range.
        %(finding the average particle velocity from the energy
        %and then using that velocity to work out how long it is in the
        %solenoid for and dividing that by the gmr*8 in this case. The 8
        %means that each B step should rotate the spin by pi/8.)
        velocity = sqrt(((2*1.6e-19)*(component(1).beamenergy)*(10^-3))/(3.016*1.66*(10^-27)));
        bstep = ((pi*velocity)/(8*gamma*component(13).length));
        for fieldstep = -15:15
            fieldstep
            % save the solenoid field to the correct place in the solenoid
            % field vector.
            solenoidfield = bstep*(fieldstep); %increases each time
            sfields(fieldstep+16,energystep,sets) = solenoidfield;
            
            % run the whole simultion through the machine.
    %%
            [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);
    %%
            [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),component(2).radius,component(2).length,component(2).fieldstrength);
    %%
            %[particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,3),component(3).gaussparam);

            [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,4),component(4).entrytype);
    %%
            %calibration solenoid
            [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,13),component(13).radius,component(13).length,component(13).GyroMagneticRatio,solenoidfield,component(13).entrytype);
    %%
            [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,5),component(5).radius,component(5).length,component(5).GyroMagneticRatio,component(5).fieldstrength,component(5).entrytype);
    %%
            [particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,6));
    %%
            [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,7),component(7).radius,component(7).length,component(7).GyroMagneticRatio,component(7).fieldstrength,component(7).entrytype);
    %%
            [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,8),component(8).entrytype);
    %%
            %[particles,trajectories] = hexapoledipoletransition(particles,trajectories,parameters(:,:,9),component(9).gaussparam);
            
            if sets == 3
                component(12).radius = 0.5e-3; %if it's on the third run, add the blocking aperture here
                [particles,trajectories] = realblockaperture(particles,trajectories,parameters(:,:,12),component(12).radius,component(12).width,component(12).height);
        
            end
      %%      
            [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,10),component(10).radius,component(10).length,component(10).fieldstrength);
%%
            %calculate true polarisation by analysing beam after analyser,
            %only on the run where the calibration solenoid is off
            
            if fieldstep == 0
                %calculate the true beam polarisation when the calibration
                %solenoid is off
                alphaweight = 0;
                betaweight = 0; 
                for int = 1:numel(particles)
                    if particles(int).spin(1,1) == 0
                        betaweight = betaweight + particles(int).weight; %total weight of beta particles (defocused)
                    else
                        alphaweight = alphaweight + particles(int).weight; %total weight of alpha particles (focused)
                    end
                end
                Pvector(energystep,1) = (alphaweight-betaweight)/(alphaweight+betaweight); %find true polarisation for this energy step
            end
            
            [particles,trajectories] = simpledetector(particles,trajectories,parameters(:,:,11),component(11).radius);%detector
            %calculate the measured weight at the detector by just adding
            %up the weight of all particles that pass through
            tweight = 0;
            for int = 1:numel(particles)
                tweight = particles(int).weight + tweight;
            end
            Wvector(fieldstep+16,energystep,sets) = tweight;
            %save this weight to the correct point
        end
    end
end

%% find the cosine curve parameters
energy = [5:5:40]
f = fittype('(A*cos(omega0*(x)-delta))+C','coefficients',{'A','delta','C','omega0'}) %general cosine fit
pmeasvector = zeros(8,3) %empty vector for storing measured polarisations
for set = 1:3
    for int = 1:8
        %make guesses for A, C and delta based on what we expect
        Aguess = (max(Wvector(:,int,set))-min(Wvector(:,int,set)))/2 
        deltaguess = 0
        Cguess = (max(Wvector(:,int,set))+min(Wvector(:,int,set)))/2
        figure
        hold on
        plot(sfields(:,int,set),Wvector(:,int,set))
        %plot the cosine curves
        title([set int])
        c = fit(sfields(:,int,set),Wvector(:,int,set),f,'startpoint',[Aguess,deltaguess,Cguess,20000])
        %attempt to fit the cosine curve
        plot(c)
        %plot this on the graph
        ylim([0 inf])
        %if the fitted amplitude is within 0.6 of the guess
        if (2*c.A)/(2*Aguess)>0.6
            pmeasvector(int,set) = (c.A)/(c.C) %pull the measured polarisation from the parameters
        end 
        hold off
    end
end

%plot the final curve.
figure
hold on
plot(energy,Pvector(:,1))
plot(energy,pmeasvector(:,1))
plot(energy,pmeasvector(:,2))
plot(energy,pmeasvector(:,3))

legend(['True polarisation'],['Measured polarisation(6mm Detector)'], ['Measured polarisation(2.4mm detector)'],['Measured polarisation(2.4mm detector and 1mm blocking aperture)'])
toc
