function [radars, countRadars, fov] = Radars()
    fov = [120;40];

    radars = { ...
        fusionRadarSensor(1,...
            'UpdateRate',0.1,... 10 sec
            'ScanMode','No scanning',...
            'MountingAngles',[0 90 0],... look up
            'FieldOfView',fov,... degrees
            'ReferenceRange',2000e3,... m
            'RangeLimits',  [0 2000e3], ... m
            'ReferenceRCS', 10,... dBsm
            'HasFalseAlarms',false,...
            'HasNoise', true,...
            'HasElevation',true,...
            'AzimuthResolution',0.03,... degrees
            'ElevationResolution',0.03,... degrees
            'RangeResolution',2000, ... m % accuracy ~= 2000 * 0.05 (m)
            'DetectionCoordinates','Sensor Spherical',...
            'TargetReportFormat','Detections',...
            'DetectionMode', 'Monostatic',...
            'InterferenceInputPort', false,...
            'EmissionsInputPort', false),...
        fusionRadarSensor(2,...
            'UpdateRate',0.1,... 10 sec
            'ScanMode','No scanning',...
            'MountingAngles',[0 90 0],... look up
            'FieldOfView',fov,... degrees
            'ReferenceRange',2000e3,... m
            'RangeLimits',  [0 2000e3], ... m
            'ReferenceRCS', 10,... dBsm
            'HasFalseAlarms',false,...
            'HasNoise', true,...
            'HasElevation',true,...
            'AzimuthResolution',0.03,... degrees
            'ElevationResolution',0.03,... degrees
            'RangeResolution',2000, ... m % accuracy ~= 2000 * 0.05 (m)
            'DetectionCoordinates','Sensor Spherical',...
            'TargetReportFormat','Detections',...
            'DetectionMode', 'Monostatic',...
            'InterferenceInputPort', false,...
            'EmissionsInputPort', false),...
        fusionRadarSensor(3,...
            'UpdateRate',0.1,... 10 sec
            'ScanMode','No scanning',...
            'MountingAngles',[0 90 0],... look up
            'FieldOfView',fov,... degrees
            'ReferenceRange',2000e3,... m
            'RangeLimits',  [0 2000e3], ... m
            'ReferenceRCS', 10,... dBsm
            'HasFalseAlarms',false,...
            'HasNoise', true,...
            'HasElevation',true,...
            'AzimuthResolution',0.03,... degrees
            'ElevationResolution',0.03,... degrees
            'RangeResolution',2000, ... m % accuracy ~= 2000 * 0.05 (m)
            'DetectionCoordinates','Sensor Spherical',...
            'TargetReportFormat','Detections',...
            'DetectionMode', 'Monostatic',...
            'InterferenceInputPort', false,...
            'EmissionsInputPort', false)...
        };

    countRadars = width(radars);
end