function x = Rev(number)
%DEBUG     fprintf("Number: "+number+"\n");
    x= number -floor(number/360.0)*360 ;
%DEBUG     fprintf("x: "+x+"\n");
end