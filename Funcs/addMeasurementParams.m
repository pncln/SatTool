function dets = addMeasurementParams(dets, numdets, stationList)
    if height(dets) ~= 0
        for i = 1: width(stationList)
            Recef2station = dcmecef2ned(stationList(i).Latitude, stationList(i).Longitude);
            for j=1:numdets
                dets{i, j}.MeasurementParameters
                currentPos = [stationList(i).Latitude stationList(i).Longitude stationList(i).Altitude];
                dets{i, j}.MeasurementParameters.OriginPosition = lla2ecef(currentPos)
                dets{i, j}.MeasurementParameters.IsParentToChild = true
                dets{i, j}.MeasurementParameters.Orientation = ...
                dets{i, j}.MeasurementParameters.Orientation' * Recef2station
            end
        end
    end
end