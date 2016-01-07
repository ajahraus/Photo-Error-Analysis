function createPHOfile(filename,I)
% createPHOfile(filename,I)
% This file takes an array of ImageClass objects, which have already
% made observations of object points, and outputs a file, specified by the
% input file name, with the appropriate format for input into the FEMBUN
% program. i.e. point name, image name, xcoord, ycoord
    
    fileID = fopen(filename,'w');
    for i = 1:length(I)
        for j = 1:length(I(i).imageData)
        outputString = [I(i).imageData(j).point.pointName, '    ' ...
            I(i).ImageID, '    ',  ...
            num2str(I(i).imageData(j).coords(1),6),'  '...
            num2str(I(i).imageData(j).coords(2),6),'\n'];
        fprintf(fileID, outputString);
        end
    end
    fprintf(fileID, '\n');
    fclose(fileID);
    

end
