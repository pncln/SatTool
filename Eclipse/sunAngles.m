function [dcalc] = sun_angles(SatLon,d)
SatLon=360-SatLon;
 
dcalc=d; 

w=282.9404 + 4.70935E-5 * dcalc;
a=1;

e= 0.016709 - 1.151E-9 * dcalc ;
M= 356.0470 + 0.9856002585 * dcalc;
oblecl = 23.4393 - 3.563E-7 * dcalc;
L=w+Rev(M);
L=Rev(L);

E=M+ (180/pi)*e*sin(Radians(M))*(  1+e * cos(Radians(M))    );
E=Rev(E);
x= a*cos(Radians(E)) - e ;
y= a*sin(Radians(Rev(E)))*sqrt(1-e^2);
r=sqrt(x*x+y*y);
v=Deg(atan2(y,x));
sunlon=Rev(v+w);

x=r*cos(Radians(sunlon));
y=r*sin(Radians(sunlon));
z=0;

xequat=x;
yequat=y*cos(Radians(oblecl)) +z*sin(Radians(oblecl));

RA=Rev(Deg(atan2(yequat,xequat)));


GMST0=(L+180);

% UT=dcalc-floor(dcalc);
%DEBUG fprintf("UT1: " +UT+"\n");

UT=Rev(0*180+RA-GMST0-SatLon+180)/360;
dcalc=floor(dcalc)+UT;
fprintf("UT2: " +UT+"\n");
fprintf("DCALC: " + dcalc+"\n");
end