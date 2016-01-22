function [points, stdev] = readVarianceFromFEBMUNoutput(filename)
fid = fopen(['C://FEMBUN2016//',filename,'.out']);
rawFile = fscanf(fid,'%s');
startPoint = 0;
for i = 1:length(rawFile)-33
    
    if strcmp('OBJECTPOINTSTANDARDERRORELLIPSOIDS', rawFile(i:i+33))
        startPoint = i;
    end
    
    if strcmp('Minimumellipsoidaxisatpoint', rawFile(i:i+26))
        endPoint = i-1;
        break
    end
end

sectionOfInterest = rawFile(startPoint+171:endPoint-44);

points = [];
stdev = [];
for i = 1:length(sectionOfInterest)-15
    if strcmp(sectionOfInterest(i), 'P')
        points = [points; sectionOfInterest(i:i+10)];
        stdev = [stdev; str2double(sectionOfInterest(i+11:i+15))];
    end
end