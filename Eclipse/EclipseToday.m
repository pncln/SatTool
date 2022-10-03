function [beta, start_eclipse, end_eclipse, total_eclipse] = EclipseToday(time, west_angle)
    r_sat=42164.57;
    r_earth=6378.14;
    
    t = datetime(time);
    jd = juliandate(t);
%     fprintf("JD: " + jd + "\n"); % DBG
    jd = jd - 2451543.5;
    
    Day = day(t);
    NextDay = Day + 1;
    Month = month(t);
    Year = year(t);
    d = daynumber(Day,Month,Year,0,0,0);
    R=r_earth/r_sat;
    orbital_period=2*pi*sqrt((r_sat)^3/398600.5)/(60*60*24);
    
    satellite_time=Rev(west_angle)*(24/360)/24;
    west_position=west_angle;
    d=floor(d);
    d=d+satellite_time;
    
    d=sunAngles(west_position,d);
    beta=sunDecl(d);
    
    %%%%%%%%%%%%%%% DBG %%%%%%%%%%%%%%%
    % qwerty = cos(beta);
    % uiop = 1/qwerty;
    % sdsds = acos(uiop);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t = acos(sqrt(1-R^2)/cos(beta)) * (orbital_period/pi) ;
    start_eclipse=((d-t/2)+10956)*24*60*60;
    end_eclipse=((d+t/2)+10956)*24*60*60;
    total_eclipse=t;
end
