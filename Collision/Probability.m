function [ result ] = Probability()
    xmax = sqrt(HBR^2 - z^2);
    xmin = -sqrt(xmax);
    zmax = HBR;
    zmin = -zmax;

    r_norm = (r_1 - r_2) / norm(r_1 - r_2);
    v_norm = (v_1 - v_2) / norm(v_1 - v_2);
    z_norm = cross(r_norm, v_norm);
    M = [r_norm v_norm z_norm];
    
    rho_conj = M * rho;
    C_comb = M * (C_1 + C_2) * M.';

    foo = @x -1/2 * rho_conj.' * C_comb^(-1) * rho_conj;
    foo2 = integral(foo, -xmin, xmax);
    foo3 = integral(foo2, -zmin, zmax);

    P_c = 1/(2*pi*sqrt(abs(C))) * foo3;
    result = P_c;
end