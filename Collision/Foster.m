function [Pc,Arem,IsRemediated] = Foster(r1,v1,cov1,r2,v2,cov2,HBR,RelTol)
    covcomb = cov1(1:3,1:3) + cov2(1:3,1:3);
    
    r = r1 - r2;
    v = v1 - v2;
    h = cross(r,v);
    
    y = v / norm(v);
    z = h / norm(h);
    x = cross(y,z);
    
    eci2xyz = [x; y; z];
    
    covcombxyz = eci2xyz * covcomb * eci2xyz';
    
    Cp = [1 0 0; 
          0 0 1] * covcombxyz * [1 0 0;
                                 0 0 1]';
    
    Lclip = (1e-4*HBR)^2;
    [~,~,~,~,IsRemediated,Adet,Ainv,Arem] = CovRemEigValClip(Cp,Lclip);

    x0 = norm(r);
    z0 = 0;
    
    C  = Ainv;
    
    AbsTol = 1e-13;

    Integrand = @(x,z)exp(-1/2*(C(1,1).*x.^2+C(1,2)*z.*x+C(2,1)*z.*x+C(2,2)*z.^2));
    
    upper_semicircle = @(x)( sqrt(HBR.^2 - (x-x0).^2) .* (abs(x-x0)<=HBR));
    lower_semicircle = @(x)(-sqrt(HBR.^2 - (x-x0).^2) .* (abs(x-x0)<=HBR));
    Pc = 1/(2*pi)*1/sqrt(Adet)*quad2d(Integrand,x0-HBR,x0+HBR,lower_semicircle,upper_semicircle,'AbsTol',AbsTol,'RelTol',RelTol);
            
    
return  