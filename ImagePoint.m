classdef ImagePoint
    properties
        cameraName
        imageName
        point
        coordinates
        
    end
    methods
        function obj = ImagePoint(img, pnt,imgCoords)
            if nargin > 0
                obj.imageName = img.ImageID;
                obj.cameraName = img.camera.cameraID;
                obj.point = pnt;
                obj.coords  = imgCoords;
                
            end
        end
    end
end