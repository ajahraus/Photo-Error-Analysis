function createINPfileFreeNetwork(filename,I,points)
% createINPfile(filename,I)
% This file takes an array of ImageClass objects, which have already
% made observations of object points, and outputs a file, specified by the
% input file name, with the appropriate format for input into the FEMBUN
% program. In this case, it outputs the EOPs of images, the IOPs of images,
% Control Point, and tie point approximate coordinates

fileID = fopen(filename,'w');

% EOPs
fprintf(fileID, 'EXTERIOR \n');

for i = 1:length(I)
    outputString = [I(i).ImageID, '    ',....
        num2str(I(i).camera.cameraID), '    '...
        num2str(I(i).location),'    ',...
        num2str(I(i).direction*180/pi), '\n'];
    fprintf(fileID, outputString);
    
    fprintf(fileID,'\n');
    
end

% IOPs
fprintf(fileID, 'INTERIOR \n');

fprintf(fileID, [I(1).camera.cameraID,' 1 \n']);
fprintf(fileID, ['0 0 ', num2str(I(1).camera.principleDistance), '\n\n']);

% Distance
fprintf(fileID, 'DISTANCE \n');

for j = 1:4
    goal_dist = (60-(j*10))/100;
    
    point1idx = ceil(rand(1)*length(points));
    dist = ones(size(points))*1000;
    for i = 1:length(points)
        if i ~= point1idx
            dist(i) = sqrt( (points(i).xyz(1) - points(point1idx).xyz(1)).^2 ...
                +(points(i).xyz(2) - points(point1idx).xyz(2)).^2 ...
                +(points(i).xyz(3) - points(point1idx).xyz(3)).^2 );
        end
    end
    [~,point2idx ] = min(abs(dist - goal_dist));
    
    
    
    outputString = [points(point1idx).pointName, ' ', points(point2idx).pointName,' ',...
        num2str(norm(points(point1idx).xyz - points(point2idx).xyz)), ' 0.001 3\n'];
    fprintf(fileID, outputString);
    
end

% Control points
fprintf(fileID, 'CONTROL\n');

for i = 1:length(points)
    if points(i).numObs > 1
        outputString = [points(i).pointName, '   ', ...
            num2str(points(i).xyz),' 0.05 0.05 0.05  \n'];
        fprintf(fileID, outputString);
    end
end
fprintf(fileID, '\n');

fclose(fileID);
end
