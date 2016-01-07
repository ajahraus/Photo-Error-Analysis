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
        
    end
    fprintf(fileID, '\n');
    
    % IOPs
    fprintf(fileID, 'INTERIOR \n');
    
    fprintf(fileID, [I(1).camera.cameraID,'  ', num2str(-1),  '\n']);
    fprintf(fileID, [num2str(I(1).camera.principleDistance), ' 0 0 \n\n']);

    % Tie points
    fprintf(fileID, 'CONTROL\n');
    
    
    for i = 1:length(points)
        outputString = [points(i).pointName, '   ', ...
            num2str(points(i).xyz),'\n'];
        fprintf(fileID, outputString);
    end
    
    fprintf(fileID, '\n');
    
    fclose(fileID);
end
