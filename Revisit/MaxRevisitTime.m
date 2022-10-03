function [ maxRevisitTime ] = MaxRevisitTime(satellite, stationList)
    cameraFOV = 30;
    objectStation = stationList(1);
    g = gimbal(satellite);
    pointAt(g, objectStation);
    camSensor = conicalSensor(g, MaxViewAngle = cameraFOV);
    ac = access(camSensor, objectStation);
    fieldOfView(camSensor);

    intervals = accessIntervals(ac);
    startTimes = intervals.StartTime;
    endTimes = intervals.EndTime;
    revisitTimes = hours(startTimes(2: end) - endTimes(1: end-1));
    maxRevisitTime = max(revisitTimes);
end