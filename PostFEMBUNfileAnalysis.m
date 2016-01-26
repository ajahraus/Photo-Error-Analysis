% Post FEMBUN file analysis
clc

[a,b] = readVarianceFromFEBMUNoutput('LargeTest2');

pointNameArray = '1234567890a';
pointNameArray = repmat(pointNameArray,length(points),1);

for i = 1:length(points)
    pointNameArray(i,:) = points(i).pointName;
end

% I need to go through the list of points, and assign the variance from the
% FEMBUN file to those points based on the matching ID. Then I can output
% the 4xn matrix as a pts file. I'll have to do the same thing for the TLS
% data as well, then I can import them both into cloudcompare and use that
% software to scale and display the colour appropriately. 
%%

for i = 1:length(a)
    for  j = 1:length(points)
        if strcmp(a(i,:), pointNameArray(j,:))
            points(j).stdev = b(i);
            break;
        end
        
    end
end
