%% program funciton
%This is a program which is the source, hexapole, solenoid, hexapole,
%detector, and it should plot the beam polarisation as a function of
%solenoid field.

% the following instruments are first defined (in a straight line)

%Source
%Hexapole1
%Dipole1
%Solenoid
%Dipole2
%Hexapole2
%%
clear all
close all
%% initialise

%NUMBER OF PARTICLES GENERATED
N = 1000

%SOURCE
sourceangles = [0 0 0] %[ALPHA BETA GAMMA];
[nz,nx] = angletonormalvector(sourceangles);
sourceparameters = [0 0 0; nz; nx];
sourceradius = 0.25e-3;
beamenergy = 10 %meV

%HEXAPOLE 1
hexapole1angles = [0 0 0]
[nz,nx] = angletonormalvector(hexapole1angles);
hexapole1parameters = [0 0 220e-3; nz; nx]
hexapole1radius = 1e-3
hexapole1length = 300e-3
hexapole1fieldstr = 1.1

%DIPOLE 1
dipole1angles = [0 0 0]
[nz,nx] = angletonormalvector(dipole1angles)
dipole1parameters = [0 0 520e-3; nz; nx]
dipole1entrytype = 'smooth'
dipole1exittype = 'sudden'


%DIPOLE 2
dipole2angles = [0 0 0]
[nz,nx] = angletonormalvector(dipole2angles)
dipole2parameters = [0 0 1270e-3; nz; nx]
dipole2entrytype = 'sudden'
dipole2exittype = 'smooth'

%HEXAPOLE 2
hexapole2angles = [0 0 0]
[nz,nx] = angletonormalvector(hexapole2angles);
hexapole2parameters = [0 0 1270e-3; nz; nx]
hexapole2radius = 2.4e-3
hexapole2length = 800e-3
hexapole2fieldstr = 1.25

%DETECTOR
detectorangles = [0 0 0] %[ALPHA BETA GAMMA];
[nz,nx] = angletonormalvector(detectorangles);
detectorparameters = [0 0 2070e-3; nz;nx];
detectorradius = 0.5e-3;

%% for loop to iterate over different solenoid field strengths
pvector = zeros(701,1)
for fieldstep = -300:300
    step = fieldstep
    %SOLENOID 1
    solenoid1angles = [0 0 0];
    [nz,nx] = angletonormalvector(solenoid1angles);
    solenoid1parameters = [0 0 520e-3;nz;nx];
    solenoid1radius = 1e-3;
    solenoid1length = 750e-3;
    solenoid1field = 2e-6*(fieldstep); %increases each time
    GyroMagneticRatio = -203.789*(10^6);
    %% source
    [particles,trajectories] = simplesourcev2(N,sourceparameters,sourceradius,100e-3,beamenergy);
    %% hexapole 1
    [particles,trajectories] = hexapole(particles,trajectories,hexapole1parameters,hexapole1radius,hexapole1length,hexapole1fieldstr);
    %% dipole 1
    [particles,trajectories] = dipole(particles,trajectories,dipole1parameters,dipole1entrytype,dipole1exittype);
    %% solenoid 
    [particles,trajectories] = solenoid(particles,trajectories,solenoid1parameters,solenoid1radius,solenoid1length,GyroMagneticRatio,solenoid1field);
    %% dipole 2
    [particles,trajectories] = dipole(particles,trajectories,dipole2parameters,dipole2entrytype,dipole2exittype);
    %% hexapole2
    [particles,trajectories] = hexapole(particles,trajectories,hexapole2parameters,hexapole2radius,hexapole2length,hexapole2fieldstr);
    %%
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