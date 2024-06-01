
% coder.extrinsic('satellite', 'groundTrack', 'orbitalElements', 'trackingGlobeViewer', ...
%     'dcmecef2ned', 'datestr', 'states', 'lla2ecef');
% covcon = zeros(9999);

% Add Paths
fprintf("====================== DEBUG ======================\n");
% Debug in the following paths/files:
% ./Eclipse/sunAngles.m
% ./Eclipse/sunDeclm

Paths(); % Include paths

% Specify date
StartTime = datetime("2022-09-29T04:29:42"); % TLE DATE
PrevTime = datetime("2022-09-28T04:29:42"); % PREV TLE DATE

% Simulation Interval
SimulationTime = 4;

StopTime = StartTime + hours(SimulationTime);
PrevStopTime = PrevTime + hours(SimulationTime);
SampleTime = 30;
satscene = satelliteScenario(StartTime, StopTime, ...
    SampleTime);
satscene_prev = satelliteScenario(PrevTime, PrevStopTime, SampleTime);
numSteps = ceil(seconds(StopTime - StartTime)/SampleTime);

% Import SAT data
SAT = satellite(satscene, "sat.tle");
prevSAT = satellite(satscene_prev, "prev.tle");

[radars, countRadars, fov] = Radars();
[tracker] = Tracker();
[stations, countStations] = Stations();
stationList = GetGroundStations(stations, satscene);
% play(satscene);
groundTrack(SAT, "LeadTime", 1200);

Props = orbitalElements(SAT(1));

viewer = trackingGlobeViewer('ShowDroppedTracks', false, 'PlatformHistoryDepth', 700);


for i=1: countStations
    ned{i} = dcmecef2ned(stationList(i).Latitude, stationList(i).Longitude);
%     ned1 = dcmecef2ned(station1(1), station1(2));
    temp = [stationList(i).Latitude stationList(i).Longitude stationList(i).Altitude];
    covcon(i) = coverageConfig(radars(i), lla2ecef(temp), quaternion(ned{i}, 'rotmat', 'frame'));
end


plotCoverage(viewer, covcon, 'ECEF');

% Constel. positions and velocity
plats = repmat(...
    struct('PlatformID', 0, 'Position', [0 0 0], 'Velocity', [0,0,0]), ...
    numSteps, 2);
for i=1:numel(SAT)
    [pos, vel] = states(SAT(i), 'CoordinateFrame',"ECEF");
    for j=1:numSteps
        plats(j,i).Position = pos(:,j)';
        plats(j,i).Velocity = vel(:,j)';
        plats(j,i).PlatformID = i;
    end
end

trackLog = cell(1, numSteps);
radarplt = helperRadarPlot(fov);

DetectConstellation(SampleTime, stationList, ...
                            plats, numSteps, radars, radarplt, tracker,...
                            viewer, covcon);

% figure;
% snapshot(viewer);

% Access Analysis
AccessData = AccessAnalysis(SAT, stationList);

% Eclipse
[ state, stateGeo ] = GetFirstState(SAT(1), StartTime);
state = state';
west_angle = lookangles([0 0 0], state);
[ sunInclination, start_eclipse, end_eclipse, total_eclipse ] = EclipseToday(StartTime, west_angle);

% Revisit Time
[ maxRevisitTime ] = MaxRevisitTime(SAT(1), stationList);
if isempty(maxRevisitTime)
    maxRevisitTime = "NA";
end


% Distance Between Satellites 1 & 2
[ distance ] = Distance(SAT(1), SAT(2), StartTime);
[ SAT1covmat ] = CovarMatrix(SAT(1), prevSAT(1), StartTime, PrevTime);
[ SAT2covmat ] = CovarMatrix(SAT(2), prevSAT(2), StartTime, PrevTime);

% Collision Probability
[ ~, stateGeo1, ~, velGeo1 ] = GetFirstState(SAT(1), StartTime);
[ ~, stateGeo2, ~, velGeo2 ] = GetFirstState(SAT(2), StartTime);
stateECI1 = ecef2eci(StartTime, stateGeo1);
velECI1 = ecef2eci(StartTime, velGeo1);
stateECI2 = ecef2eci(StartTime, stateGeo2);
velECI2 = ecef2eci(StartTime, velGeo2);

r1 = stateECI1';
r2 = stateECI2';
v1 = velECI1';
v2 = velECI2';
C1 = SAT1covmat;
C2 = SAT2covmat;
  r1      = [378.39559 4305.721887 5752.767554];
  v1      = [2.360800244 5.580331936 -4.322349039];
  r2      = [374.5180598 4307.560983 5751.130418];
  v2      = [-5.388125081 -3.946827739 3.322820358];
cov1    = [44.5757544811362  81.6751751052616  -67.8687662707124;
         81.6751751052616  158.453402956163  -128.616921644857;
         -67.8687662707124 -128.616921644858 105.490542562701];
cov2    = [2.31067077720423  1.69905293875632  -1.4170164577661;
         1.69905293875632  1.24957388457206  -1.04174164279599;
         -1.4170164577661  -1.04174164279599 0.869260558223714];
% C1 = cov1;
% C2 = cov2;
HBR = 0.020;

[ P_c, Arem ] = Foster(r1, v1, C1, r2, v2, C2, HBR, 1e-08);
Arem = Arem / 10e12;
x1 = r1 ./ v1;
x2 = r2 ./ v2;
% [ dt ] = FindNearbyCA(x1, x2, 'LINEAR', 10e-2);

fprintf("===================== RESULTS =====================\n");
    fprintf("[General] Date: " + datestr(StartTime) + "\n");
    fprintf("[General] Sun Inclination: " + Deg(sunInclination) + " [deg]\n");
    fprintf("[Eclipse] Start time (UTC): " + datestr(datetime(start_eclipse, 'convertfrom','posixtime')) + "\n");
    fprintf("[Eclipse] End time (UTC): " + datestr(datetime(end_eclipse, 'convertfrom','posixtime')) + "\n");
    fprintf("[Eclipse] Duration: " + toHms(total_eclipse) + "");
    fprintf("[Revisit Time] Max Revisit Time: " + maxRevisitTime + " [h]\n");
    fprintf("[Collision] Distance Between Satellites: " + distance/(10^3) + " [km]\n");
    fprintf("[Collision] Probability of Collision: " + P_c + "\n");
    % fprintf("[Collision] Time offset: " dTCA);
    fprintf("[Collision] Combined Covariance: " + Arem(1) + " | " + Arem(2) + " | " + Arem(3) + " | " + Arem(4) + " (10e12)" + "\n");
fprintf("===================================================\n");

% for i=1: numel(SAT)
%     for j=1: numel(stations)
%         AccessAnalysis = access(SAT(i), stations(j,:));
%         AccessIntervals(i) = accessIntervals(AccessAnalysis);
%     end
% end