function [ AccessData ] = AccessAnalysis(SAT, stationList)
    for i=1: numel(SAT)
        for j=1: numel(stationList)
            ac = access(SAT(i), stationList(j));
            ai = accessIntervals(ac);
            AccessData{i,j} = ai;
        end
    end
end