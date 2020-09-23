function trajectories = addtotrajectories(particles,trajectories,param) 
%This function takes the current position of all particles in the component frame, converts them
%into the lab frame and adds them to the trajectory list. This is usually
%called right after the trajectories and particles corresponding to
%trajectories that have left the instrument have been removed from the
%structures.


for i = 1:numel(particles)
    [~,pos] = labtransform(particles(i).velocity,particles(i).position,param);
    trajectories(i).position(((trajectories(i).Numberofentries)+1),:) = pos;
    trajectories(i).Numberofentries = trajectories(i).Numberofentries + 1;
    trajectories(i).spin(trajectories(i).Numberofentries,:) = particles(i).spin;
end
end