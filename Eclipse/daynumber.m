function result = daynumber(Day, Month, Year, Hour, Minute, Second)
    result = 367*Year - Div(  (7*(Year+(Div((Month+9),12)))),4 ) + ...
    Div((275*Month),9) + Day - 730530;
    result=result+ Hour/24 + Minute/(60*24) + Second/(24*60*60);
end