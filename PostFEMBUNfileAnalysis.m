% Post FEMBUN file analysis
clc

[fixedPointNames,fixedStds] = readVarianceFromFEBMUNoutput('LargeTest1');
[freePointNames,freeStds] = readVarianceFromFEBMUNoutput('LargeTest1');


%%

for i = 1:length(fixedPointNames)
    for  j = 1:length(points)
        if strcmp(fixedPointNames(i,:), points(j).pointName)
            points(j).stdFixed = fixedStds(i);
            break;
        end
    end
end

for i = 1:length(freePointNames)
    for  j = 1:length(points)
        if strcmp(freePointNames(i,:), points(j).pointName)
            points(j).stdFN = freeStds(i);
            break;
        end
    end
end


%% Output pts file (Fixed)

fid = fopen('PhotoPointCloudFixed.pts','w');

fprintf(fid, num2str(length(points)));
fprintf(fid, '\n');
for i =  1:length(points)
    outputString = [num2str(points(i).xyz(1)),', ',num2str(points(i).xyz(2)),...
        ', ',num2str(points(i).xyz(3)),', ',num2str(points(i).stdFixed),'\n'];
    if points(i).stdFixed ~= 0;
        fprintf(fid,outputString);
    end
end
fclose(fid);

%% Output pts file (Free network)

fid = fopen('PhotoPointCloudFree.pts','w');

fprintf(fid, num2str(length(points)));
fprintf(fid, '\n');
for i =  1:length(points)
    outputString = [num2str(points(i).xyz(1)),', ',num2str(points(i).xyz(2)),...
        ', ',num2str(points(i).xyz(3)),', ',num2str(points(i).stdFN),'\n'];
    if points(i).stdFN ~= 0;
        fprintf(fid,outputString);
    end
end
fclose(fid);
