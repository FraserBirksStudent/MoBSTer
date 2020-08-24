function trajectories = addtotrajectories(particles,trajectories,param) 
%This function takes the current position of all particles, converts them
%into the lab frame and adds them to the trajectory list. This is usually
%called right after the trajectories and particles corresponding to
%trajectories that have left the instrument have been removed from the
%structures.
%NOTE MUST ADD THE PART THAT ADDS THE MAGNETIC FIELD VECTOR AT EACH POINT
%TO THE TRAJECTORY VECTOR IN ORDER TO PROPERLY SPECIFY THE MAGNETIC FIELD
%AT EACH POINT.
for i = 1:numel(particles)
    [~,pos] = labtransform(particles(i).velocity,particles(i).position,param);
    trajectories(i).position(((trajectories(i).Numberofentries)+1),:) = pos;
    trajectories(i).Numberofentries = trajectories(i).Numberofentries + 1;
end
end