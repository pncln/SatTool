function filter = initKeplerUKF(detection)

radarsphmeas = detection.Measurement;
[x, y, z] = sph2cart(deg2rad(radarsphmeas(1)),deg2rad(radarsphmeas(2)),radarsphmeas(3));
radarcartmeas = [x y z];
Recef2radar = detection.MeasurementParameters.Orientation;
ecefmeas = detection.MeasurementParameters.OriginPosition + radarcartmeas*Recef2radar;

initState = [ecefmeas(1); 0; ecefmeas(2); 0; ecefmeas(3); 0];

sigpos = 2;% m
sigvel = 0.5;% m/s^2

filter = trackingUKF(@keplerorbit,@cvmeas,initState,...
    'Alpha', 1, 'Beta', 0, 'Kappa', 0, ...
    'StateCovariance', diag(repmat([1000, 10000].^2,1,3)),...
    'ProcessNoise',diag(repmat([sigpos, sigvel].^2,1,3)));

end

function state = keplerorbit(state,dt)
k1 = kepler(state);
k2 = kepler(state + dt*k1/2);
k3 = kepler(state + dt*k2/2);
k4 = kepler(state + dt*k3);

state = state + dt*(k1+2*k2+2*k3+k4)/6;

    function dstate=kepler(state)
        x =state(1,:);
        vx = state(2,:);
        y=state(3,:);
        vy = state(4,:);
        z=state(5,:);
        vz = state(6,:);

        mu = 398600.4405*1e9; % m^3 s^-2
        omega = 7.292115e-5; % rad/s
        
        r = norm([x y z]);
        g = mu/r^2;
        
        ax = -g*x/r + 2*omega*vy + omega^2*x;
        ay = -g*y/r - 2*omega*vx + omega^2*y;
        az = -g*z/r;
        dstate = [vx;ax;vy;ay;vz;az];
    end
end