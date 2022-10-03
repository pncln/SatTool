function [state, stateGeo, vel, velGeo] = GetFirstState(satellite, time)
    [state, vel] = states(satellite, time);
    [stateGeo, velGeo] = states(satellite, time, CoordinateFrame = 'geographic');
end