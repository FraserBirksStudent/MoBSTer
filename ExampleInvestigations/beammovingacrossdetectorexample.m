%% Information
%This is an example of doing a specular scan of the sample in the cambridge
%machine layout, for different detector aperture sizes (2.4mm,6mm and 1mm
%diameter)
%The output of this is 3 graphs showing the total number that enter the
%detector of focused trajectories, defocused trajectories and the total
%weight of all the trajectories, for each of the 3 aperture sizes.
%%
clear 
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 1000;
%initialise to get the parameters vector and the component structure
[parameters,component] = initialisecambridge();
focused = zeros(41,3);
defocused = zeros(41,3);
Wvector = zeros(41,3);%Initialise the three empty vectors which will store the graphical information
component(1).beamenergy = 10 %Set the beamenergy.
%% code
for detectorsize = 1:3
    if detectorsize == 2
        component(11).radius = 3e-3; %On the second run, set the dector radius as 6mm
    end
    if detectorsize == 3
        component(11).radius = 0.5e-3;%On the third run, set the dector radius as 1mm
    end
    for run = 1:41 %Run 42 simulations for each run, with the detector angle changing by 0.005 degrees each time
        component(6).angles = [0 0 22.1+0.005*run];
        [nz,nx] = angletonormalvector(component(6).angles); 
        parameters(:,:,6) = [component(6).origin;nz;nx]; %update the source parameters vector each run
        
        % Run the simulation through the entire machine calling each
        % instrument
        
        [particles,trajectories] = simplesourcev2(N,parameters(:,:,1),component(1).radius,100e-3,component(1).beamenergy);
        [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,2),component(2).radius,component(2).length,component(2).fieldstrength);
        [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,4),component(4).entrytype);
        [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,13),component(13).radius,component(13).length,component(13).GyroMagneticRatio,component(13).fieldstrength,component(13).entrytype);
        [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,5),component(5).radius,component(5).length,component(5).GyroMagneticRatio,component(5).fieldstrength,component(5).entrytype);
        [particles,trajectories] = flatsample(particles,trajectories,parameters(:,:,6));
        [particles,trajectories] = solenoid(particles,trajectories,parameters(:,:,7),component(7).radius,component(7).length,component(7).GyroMagneticRatio,component(7).fieldstrength,component(7).entrytype);
        [particles,trajectories] = dipole(particles,trajectories,parameters(:,:,8),component(8).entrytype);
        [particles,trajectories] = hexapole(particles,trajectories,parameters(:,:,10),component(10).radius,component(10).length,component(10).fieldstrength);
        [particles,trajectories] = aperture(particles,trajectories,parameters(:,:,11),component(11).radius);%detector

        % At the end of each simulation, save the data for the focused
        % weight, defocused weight and total weight.
        
        defocusednum = 0;
        focusednum = 0;
        W = 0
        for particle = 1:numel(particles) %iterate over the particles structure
            if particles(particle).spin(1,1) == 0 %total defocused number passing though 
                defocusednum = defocusednum + 1;
            elseif particles(particle).spin(1,2) == 0
                focusednum = focusednum + 1; % total focused number passing through
            end
            W = W+particles(particle).weight % total weight of all particles passing through
        end
        %save these values in the pre-initialised vectors
        focused(run,detectorsize) = focusednum;
        defocused(run,detectorsize) = defocusednum;
        Wvector(run,detectorsize) = W;
    end
end

%% plot all the graphs
angles = [22.105:0.005:22.1+0.005*41]

figure
hold on
title(['Number of focused trajectories with angle'])
xlabel(['angle (degrees)'])
ylabel(['Number of focused trajectories'])
plot(angles,focused(:,1))
plot(angles,focused(:,2))
plot(angles,focused(:,3))
legend(['2.4mm detector'], ['6mm detector'],['1mm detector'])

figure
hold on
title(['Number of defocused trajectories with angle'])
xlabel(['angle (degrees)'])
ylabel(['Number of defocused trajectories'])
plot(angles,defocused(:,1))
plot(angles,defocused(:,2))
plot(angles,defocused(:,3))
legend(['2.4mm detector'], ['6mm detector'],['1mm detector'])

figure
hold on
title(['Total number passing through detector with angle'])
xlabel(['angle (degrees)'])
ylabel(['Count rate'])
plot(angles,Wvector(:,1))
plot(angles,Wvector(:,2))
plot(angles,Wvector(:,3))
legend(['2.4mm detector'], ['6mm detector'],['1mm detector'])


