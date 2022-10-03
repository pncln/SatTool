function [ Distance ] = Distance(satellite1, satellite2, StartTime)
    R = 6.3781*10^6; % Earth Radius
    [ ~, stateGeo1 ] = GetFirstState(satellite1, StartTime);
    [ ~, stateGeo2 ] = GetFirstState(satellite2, StartTime);

    latitude1 = stateGeo1(1);
    longitude1 = stateGeo1(2);
    latitude2 = stateGeo2(1);
    longitude2 = stateGeo2(2);

    phi_1 = latitude1 * pi / 180;
    phi_2 = latitude2 * pi / 180;
    delta_phi = (latitude2-latitude1) * pi / 180;
    delta_lamda = (longitude2 - longitude1) * pi / 180;
    
    a = sin(delta_phi / 2) * sin(delta_phi/2) + ...
        cos(phi_1) * cos(phi_2) * ...
        sin(delta_lamda / 2) * sin(delta_lamda / 2);
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    d = R * c;
    
    Distance = d;
end