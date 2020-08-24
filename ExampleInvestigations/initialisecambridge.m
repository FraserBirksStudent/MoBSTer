function [parameters,component] = initialisecambridge()
%% define instruments
n = 9 %number of components
%generate a component structure
component = repmat(struct('name',strings,'angles',zeros(1,3),'origin',zeros(1,3),'radius',0,'length',0,'fieldstrength',0,'entrytype',strings), n, 1 );
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

%HDT 1
component(3).name = 'hexapole dipole transition'
component(3).origin = [1 0 520e-3]
component(3).angles = [0 0 0]
component(3).gaussparam = [5.7e-4 0.5 0.1]
[nz,nx] = angletonormalvector(component(3).angles)
parameters(:,:,3) = [component(3).origin;nz;nx]

%DIPOLE 1
component(4).name = 'dipole1'
component(4).angles = [0 0 0]
component(4).origin = [1 0 520e-3]
component(4).entrytype = 'smooth'
[nz,nx] = angletonormalvector(component(4).angles)
parameters(:,:,4) = [component(4).origin; nz; nx]

%SOLENOID 1
component(5).name = 'solenoid1';
component(5).angles = [0 0 0];
component(5).origin = [1 0 1020e-3]
component(5).radius = 2e-3;
component(5).length = 750e-3;
component(5).fieldstrength = 0;
component(5).GyroMagneticRatio = -203.789*(10^6)
component(5).entrytype = 'sudden';
[nz,nx] = angletonormalvector(component(5).angles);
parameters(:,:,5) = [component(5).origin;nz;nx];

%SAMPLE1
component(6).name = 'sample'
component(6).angles = [0 0 22.5] %[ALPHA BETA GAMMA];
component(6).origin = [1 0 1990e-3]
[nz,nx] = angletonormalvector(component(6).angles);
parameters(:,:,6) = [component(6).origin; nz;nx]


%SOLENOID 2
component(7).name = 'solenoid2'
component(7).angles = [0 0 225]
component(7).origin = [1 -(130e-3)*cos(pi/4) (1990e-3)-((130e-3)*cos(pi/4))]
component(7).radius = 1e-3
component(7).length = 750e-3
component(7).fieldstrength = 0
component(7).entrytype = 'smooth'
component(7).GyroMagneticRatio = -203.789*(10^6)
[nz,nx] = angletonormalvector(component(7).angles)
parameters(:,:,7) = [component(7).origin;nz;nx]

%DIPOLE 2
component(8).name = 'dipole2'
component(8).angles = [0 0 225]
component(8).origin = [1 -(880e-3)*cos(pi/4) (1990e-3)-((880e-3)*cos(pi/4))]
component(8).entrytype = 'sudden'
[nz,nx] = angletonormalvector(component(8).angles)
parameters(:,:,8) = [component(8).origin;nz;nx]

%HDT 1
component(9).name = 'hexapole dipole transition'
component(9).origin = [1 -(880e-3)*cos(pi/4) (1990e-3)-((880e-3)*cos(pi/4))]
component(9).angles = [0 0 0]
component(9).gaussparam = [5.7e-4 0.5 0.1]
[nz,nx] = angletonormalvector(component(9).angles)
parameters(:,:,3) = [component(9).origin;nz;nx]

%HEXAPOLE 2
component(10).name = 'hexapole2'
component(10).angles = [0 0 225]
component(10).origin = [1 -(1450e-3)*cos(pi/4) (1990e-3)-((1450e-3)*cos(pi/4))]
component(10).radius = 2.4e-3
component(10).length = 800e-3
component(10).fieldstrength = 1.25
[nz,nx] = angletonormalvector(component(10).angles);
parameters(:,:,10) = [component(10).origin;nz;nx]

%DETECTOR
component(11).name = 'detector'
component(11).angles = [0 0 225] %[ALPHA BETA GAMMA];
component(11).origin = [1 -(3024e-3)*cos(pi/4) (1990e-3)-((3024e-3)*cos(pi/4))]
component(11).radius = 10e-3;
[nz,nx] = angletonormalvector(component(11).angles);
parameters(:,:,11) = [component(11).origin;nz;nx]

%WRITE TO xslx file
delete 'InstrumentParameters.xlsx'
t = struct2table(component)
writetable(t,'InstrumentParameters.xlsx');
end