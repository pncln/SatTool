function detectInput = isDetectable(tracker,time,covcon)

if ~isLocked(tracker)
    detectInput = zeros(0,1,'uint32');
    return
end
tracks = tracker.predictTracksToTime('all',time);
if isempty(tracks)
    detectInput = zeros(0,1,'uint32');
else
    alltrackid = [tracks.TrackID];
    isDetectable = zeros(numel(tracks),numel(covcon),'logical');
    for i = 1:numel(tracks)
        track = tracks(i);
        pos_scene = track.State([1 3 5]);
        for j=1:numel(covcon)
            config = covcon(j);
            d_scene = pos_scene(:) - config.Position(:);
            scene2sens = rotmat(config.Orientation,'frame');
            d_sens = scene2sens*d_scene(:);
            [az,el] = cart2sph(d_sens(1),d_sens(2),d_sens(3));
            if abs(rad2deg(az)) <= config.FieldOfView(1)/2 && abs(rad2deg(el)) < config.FieldOfView(2)/2
                isDetectable(i,j) = true;
            else
                isDetectable(i,j) = false;
            end
        end
    end
    
    detectInput = alltrackid(any(isDetectable,2))';
end
end