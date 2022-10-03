function DetectConstellation(SampleTime, stationList, ...
                            plats, numSteps, radars, radarplt, tracker,...
                            viewer, covcon)
    confTracks = objectTrack.empty(0, 1);
    s = rng;
    rng(2020);
    step = 0;
    
    while step < numSteps
        time = step*SampleTime;
        step = step + 1;
    
        % Constellation detection
        for i=1: height(radars)
            targets(:, :) = assembleRadarInputs(stationList(i), plats(step, :));
            currentRadar = radars{i};
            [ deti, numdeti ] = currentRadar(targets(i), time);
            dets(:,i) = deti;
            numdets(:,i) = numdeti;
            dets(:,i) = addMeasurementParams(dets(:,i), numdets(:,i), stationList(i));
        end

%         targets1 = assembleRadarInputs(station1, plats(step, :));
%         [dets1, numdets1] = radar1(targets1, time);
%         dets1 = addMeasurementParams(dets1, numdets1, station1);
    
        detections = dets;
        updateRadarPlots(radarplt, targets, dets);
    
        detectableInput = isDetectable(tracker,time,covcon);
        if ~isempty(detections) || isLocked(tracker)
            [confTracks, ~, ~, info] = tracker(detections, time, detectableInput);
        end
        trackLog{step} = confTracks;
    
        plotPlatform(viewer, plats(step, :), 'ECEF', 'Color', [1 0 0], 'LineWidth', 1);
        plotDetection(viewer, detections, 'ECEF');
        plotTrack(viewer, confTracks, 'ECEF', 'Color', [0 1 0], 'LineWidth', 3);
         
    end
    
    rng(s);
end