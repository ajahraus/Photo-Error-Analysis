function createINPfile(filename,I,points)
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
        if i == 1
            fprintf(fileID,'0.00001 0.00001 0.00001 0.000001 0.000001 0.000001 \n');
        else
            fprintf(fileID,'\n');
        end
    end
    
    % IOPs
    fprintf(fileID, 'INTERIOR \n');
    
    fprintf(fileID, [I(1).camera.cameraID,'  ', num2str(-1),  '\n']);
    fprintf(fileID, ['0 0 ', num2str(I(1).camera.principleDistance), '\n\n']);
    
    % Distance
    fprintf(fileID, 'DISTANCE \n');
    
    point1idx = ceil(rand(1)*length(points));
    for i = 1:length(points)
        dist = sqrt( (points(i).xyz(1) - points(point1idx).xyz(1)).^2 ...
            +(points(i).xyz(2) - points(point1idx).xyz(2)).^2 ...
            +(points(i).xyz(3) - points(point1idx).xyz(3)).^2 );
        if abs(dist-1) < 0.01;
            point2idx = i;
            break;
        end
        if i == length(points)
            point1idx = ceil(rand(1)*length(points));
            i = 1;
        end
    end
    
    outputString = [points(point1idx).pointName, ' ', points(point2idx).pointName,' ',...
        num2str(dist), ' 0.00001 3\n'];
    fprintf(fileID, outputString);
    

    % Tie points
    fprintf(fileID, 'TIE\n');
    
    
    for i = 1:length(points)
        outputString = [points(i).pointName, '   ', ...
            num2str(points(i).xyz),'\n'];
        fprintf(fileID, outputString);
    end
    
    fprintf(fileID, '\n');
    
    fclose(fileID);
end
