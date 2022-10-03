% function d_to_hms(d)
function result = toHms(d)
    % fprintf("D: " + d + "\n");
    Hr = fix(d * 24);
    Min = fix((d * 24 - Hr )*60);
    Sec = fix(((d * 24 - Hr )*60-Min)*60);
    result = Hr + " Hours, " + Min + " Minutes, " + Sec + " Seconds \n";
end