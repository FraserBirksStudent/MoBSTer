function [particles,trajectories] = simplesourcev2(N, param, Radius, zspacing,beamenergy)
%% Function definition:
%this function is a much faster version of the previous simple source
%function as it uses pre-initialised arrays and structures and does not
%rely heavily on for loops
%
%this entirely works within the lab frame- as rand points returns
%coordinates in the lab frame
%
%it is assumed that the trajectories of each particle will be fully
%described by 1000 points connected by straight lines. N trajectories are
%initiated as this is the maximum number that can undergo trajectory
%splitting and hence the structure will not get bigger than this.
%% Code
Aperture1 = param;
r2 = param(1,:) - zspacing*param(2,:);
Aperture2 = [r2;param(2,:);param(3,:)];

points2 = RandPoints(N,Aperture1,Radius);
points1 = RandPoints(N,Aperture2,Radius);


vavg = sqrt((2*beamenergy*(10^-3)*1.6e-19)/(1.66*3*(10^-27)));%calculate average molecule velocity based on energy

vdist = vavg + ((vavg/10)/2.355)*randn(N,1); %calculate velocity distribution using FWHM = vavg/10

prefactors = vdist.*sqrt((1./(((points2(:,1)-points1(:,1)).^2)+((points2(:,2)-points1(:,2)).^2)+((points2(:,3)-points1(:,3)).^2))));

v = prefactors(:,1).*[points2(:,1)-points1(:,1) points2(:,2)-points1(:,2) points2(:,3)-points1(:,3)];

%generate inital z spin eigenstate coeffiecients, which are of the form
%[Calpha Cbeta] these have the property that mod(calpha)^2 + mod(cbeta)^2 =
%1
theta = rand(N,2)*2*pi;
unnormalised = cos(theta)+1i*sin(theta);
numbers = rand(N,1);
normfactors = [sqrt(numbers), sqrt(1-numbers)];
spinvector = normfactors.*unnormalised;

%store the initial postions in the trajectory structure and all the initial
%information in the particle structure
%initialise structures (Spin must be added here!)

particles = repmat(struct('position',zeros(1,3),'velocity',zeros(1,3),'spin',zeros(1,2),'weight',1,'time',0,'Bfield',[0 0 1]), N, 1 );
trajectories = repmat(struct('position',zeros(100,3),'Numberofentries',1),N,1);
for int = 1:N
    particles(int).position = points2(int,:);
    particles(int).velocity = v(int,:);
    particles(int).spin = spinvector(int,:);
    trajectories(int).position(1,:) = points2(int,:);
end
end


