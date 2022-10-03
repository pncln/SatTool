function [ Matrix ] = CovarMatrix(sat, prevSat, CurrentTime, PrevTime)
%   CovarMatrix = [ var(x) cov(x, y) cov(x, z);
%                     cov(x, y) var(y) cov(y, z);
%                     cov(x, z) cov(y, z) var(z)
%         ];
    N = 2; % Number of past TLEs
    [ ~, stateGeo1, ~, velGeo1 ] = GetFirstState(sat, CurrentTime);
    [ ~, stateGeo2, ~, velGeo2 ] = GetFirstState(prevSat, PrevTime);
    stateECEF1 = ecef2eci(CurrentTime, stateGeo1);
    velECEF1 = ecef2eci(CurrentTime, velGeo1);
    stateECEF2 = ecef2eci(PrevTime, stateGeo2);
    velECEF2 = ecef2eci(PrevTime, velGeo2);

    % Current %%%%%%%%%%%%%%
    u = stateECEF1 / norm(stateECEF1);
    w = cross(stateECEF1, velECEF1) / norm(cross(stateECEF1, velECEF1));
    v = cross(w, u) / norm(cross(w, u));

    T = [u'; v'; w'];
    
%     P_rel = stateECEF1 - stateECEF2;
%     P_ric = T * P_rel;
    
%     V_rel = velECEF1 - velECEF2;
%     V_ric = T * V_rel;

    % Previous

    u_prev = stateECEF2 / norm(stateECEF2);
    w_prev = cross(stateECEF2, velECEF2) / norm(cross(stateECEF2, velECEF2));
    v_prev = cross(w_prev, u_prev) / norm(cross(w_prev, u_prev));

    T_prev = [u_prev'; v_prev'; w_prev'];
    
    stateRSW1 = T * stateECEF1;
    stateRSW2 = T_prev * stateECEF2;

    %%%%%%%%%%%%%%%%%%%%%%%%

    x_0 = stateRSW1(1);
    y_0 = stateRSW1(2);
    z_0 = stateRSW1(3);

    x_i = stateRSW2(1);
    y_i = stateRSW2(2);
    z_i = stateRSW2(3);
    
    sigmaXX = (1/(N-1)) * (x_i - x_0) * (x_i - x_0)';
    sigmaXY = (1/(N-1)) * (x_i - x_0) * (y_i - y_0)';
    sigmaXZ= (1/(N-1)) * (x_i - x_0) * (z_i - z_0)';
    sigmaYX = (1/(N-1)) * (y_i - y_0) * (x_i - x_0)';
    sigmaYY = (1/(N-1)) * (y_i - y_0) * (y_i - y_0)';
    sigmaYZ = (1/(N-1)) * (y_i - y_0) * (z_i - z_0)';
    sigmaZX = (1/(N-1)) * (z_i - z_0) * (x_i - x_0)';
    sigmaZY = (1/(N-1)) * (z_i - z_0) * (y_i - y_0)';
    sigmaZZ = (1/(N-1)) * (z_i - z_0) * (z_i - z_0)';

    Matrix = [ sigmaXX sigmaXY sigmaXZ;
               sigmaYX sigmaYY sigmaYZ;
               sigmaZX sigmaZY sigmaZZ];
end