function [stationList] = GetGroundStations(stations, scene)
    count = height(stations);
    satscene = scene;
    for i=1:count
        stationList(i) = groundStation(satscene, stations(i, 1), stations(i, 2));
    end
end