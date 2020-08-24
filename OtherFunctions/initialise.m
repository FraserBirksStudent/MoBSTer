function [parameters,component] = initialise()
%% define instruments
n = 9 %number of components
%generate a component structure
component = repmat(struct('name',strings,'angles',zeros(1,3),'origin',zeros(1,3),'radius',0,'length',0,'fieldstrength',0,'entrytype',strings), n, 1 );
%NUMBER OF PARTICLES GENERATED
N = 500000
parameters = zeros(3,3,n)
%% SOURCE
component(1).name = 'Source'
component(1).angles = [0 0 0] %[ALPHA BETA GAMMA];
component(1).origin = [1 0 0]
component(1).radius = 0.25e-3;
component(1).beamenergy = 10;%meV
[nz,nx] = angletonormalvector(component(1).angles);
parameters(:,:,1) = [component(1).origin; nz; nx];

%HEXAPOLE 1
component(2).name = 'hexapole1'
component(2).angles = [0 0 0]
component(2).origin = [1 0 220e-3]
component(2).radius = 1e-3
component(2).length = 300e-3
component(2).fieldstrength = 1.1
[nz,nx] = angletonormalvector(component(2).angles);
parameters(:,:,2) = [component(2).origin; nz; nx]

%DIPOLE 1
component(3).name = 'dipole1'
component(3).angles = [0 0 0]
component(3).origin = [1 0 520e-3]
component(3).entrytype = 'smooth'
[nz,nx] = angletonormalvector(component(3).angles)
parameters(:,:,3) = [component(3).origin; nz; nx]

%SOLENOID 1
component(4).name = 'solenoid1';
component(4).angles = [0 0 0];
component(4).origin = [1 0 1020e-3]
component(4).radius = 2e-3;
component(4).length = 750e-3;
component(4).fieldstrength = 0;
component(4).GyroMagneticRatio = -203.789*(10^6)
component(4).entrytype = 'sudden';
[nz,nx] = angletonormalvector(component(4).angles);
parameters(:,:,4) = [component(4).origin;nz;nx];

%SAMPLE1
component(5).name = 'sample'
component(5).angles = [0 0 22.5] %[ALPHA BETA GAMMA];
component(5).origin = [1 0 1990e-3]
[nz,nx] = angletonormalvector(component(5).angles);
parameters(:,:,5) = [component(5).origin; nz;nx]


%SOLENOID 2
component(6).name = 'solenoid2'
component(6).angles = [0 0 225]
component(6).origin = [1 -(130e-3)*cos(pi/4) (1990e-3)-((130e-3)*cos(pi/4))]
component(6).radius = 1e-3
component(6).length = 750e-3
component(6).fieldstrength = 0
component(6).entrytype = 'smooth'
[nz,nx] = angletonormalvector(component(6).angles)
parameters(:,:,6) = [component(6).origin;nz;nx]

%DIPOLE 2
component(7).name = 'dipole2'
component(7).angles = [0 0 225]
component(7).origin = [1 -(880e-3)*cos(pi/4) (1990e-3)-((880e-3)*cos(pi/4))]
component(7).entrytype = 'sudden'
[nz,nx] = angletonormalvector(component(7).angles)
parameters(:,:,7) = [component(7).origin;nz;nx]

%HEXAPOLE 2
component(8).name = 'hexapole2'
component(8).angles = [0 0 225]
component(8).origin = [1 -(1450e-3)*cos(pi/4) (1990e-3)-((1450e-3)*cos(pi/4))]
component(8).radius = 2.4e-3
component(8).length = 800e-3
component(8).fieldstrength = 1.25
[nz,nx] = angletonormalvector(component(8).angles);
parameters(:,:,8) = [component(8).origin;nz;nx]

%DETECTOR
component(9).name = 'detector'
component(9).angles = [0 0 225] %[ALPHA BETA GAMMA];
component(9).origin = [1 -(3024e-3)*cos(pi/4) (1990e-3)-((3024e-3)*cos(pi/4))]
component(9).radius = 3e-3;
[nz,nx] = angletonormalvector(component(9).angles);
parameters(:,:,9) = [component(9).origin;nz;nx]

%WRITE TO xslx file
delete 'InstrumentParameters.xlsx'
t = struct2table(component)
writetable(t,'InstrumentParameters.xlsx');
end