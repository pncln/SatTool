function targets = assembleRadarInputs(station, SAT)
    Template = struct(...
        'PlatformID', 0, ...
        'Position', zeros(1, 3), ...
        'Velocity', zeros(1, 3), ...
        'ClassID', 0, ...
        'Acceleration', zeros(1,3), ...
        'Orientation', quaternion(1, 0, 0, 0), ...
        'AngularVelocity', zeros(1, 3),  ...
        'Dimensions', struct( ...
                    'Length', 0,...
                    'Width', 0, ...
                    'Height', 0, ...
                    'OriginOffest', [0 0 0]), ...
        'Signatures', {{rcsSignature}} ...
    );
%         
    

    targetPoses = repmat(Template, 1, numel(SAT));
    for i=1:numel(SAT)
        targetPoses(i).Position = SAT(i).Position;
        targetPoses(i).Velocity = SAT(i).Velocity;
        targetPoses(i).PlatformID = SAT(i).PlatformID;
    end

    Recef2station = dcmecef2ned(station.Latitude, station.Longitude); 
    radarPose.Orientation = quaternion(Recef2station, 'rotmat', 'frame');
    currentRadar_MountingLocation = [station.Latitude station.Longitude station.Altitude];
    radarPose.Position = lla2ecef(currentRadar_MountingLocation);
    radarPose.Velocity = zeros(1, 3);
    radarPose.AngularVelocity = zeros(1, 3);
    
    targets = targetPoses;
    
    for j=1: numel(targetPoses)
           Target = targetPoses(j);
           POS = Recef2station*(Target.Position(:) - radarPose.Position(:));
           ANGULARVEL = Target.AngularVelocity(:) - radarPose.AngularVelocity(:);
           ORIENTATION = radarPose.Orientation' * Target.Orientation;
           VELOCITY = Recef2station*(Target.Velocity(:) - radarPose.Velocity(:)) - cross(radarPose.AngularVelocity(:), POS(:));
   
           targets(j).Position(:) = POS;
           targets(j).Velocity(:) = VELOCITY;
           targets(j).AngularVelocity(:) = ANGULARVEL;
           targets(j).Orientation = ORIENTATION;

    end
end