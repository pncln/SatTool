% Sun declination calculator
function Decl = sunDecl(d)
    w=282.9404 + 4.70935E-5 * d ;
    e= 0.016709 - 1.151E-9 *d;
    M= 356.0470 + 0.9856002585 * d;
    oblecl=23.4393 -3.563E-7 * d;

    E=M+ (180/pi)*e*sin(Radians(M))*( 1+e * cos(Radians(M)) );
    E=Rev(E);
    x= cos(Radians(E)) -e ;
    y= sin(Radians(Rev(E)))*sqrt(1-e*e);
    r=sqrt(x*x+y*y);
    v=Deg(atan2(y,x));
    sunlon=Rev(v+w);
    
    x=r*cos(Radians(sunlon));
    y=r*sin(Radians(sunlon));
    z=0;
    
    xequat=x;
    yequat=y*cos(Radians(oblecl)) +z*sin(Radians(oblecl));
    zequat=y*sin(Radians(oblecl)) +z*cos(Radians(oblecl));
    
    RA=Rev(Deg(atan2(yequat,xequat)));
    Decl=atan2(zequat,sqrt(xequat*xequat + yequat*yequat )  );
    fprintf("DECL: "+Decl+"\n");
    fprintf("RA: "+RA+"\n");
end