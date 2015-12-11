classdef ImagePoint
    properties
        cameraName
        imageName
        pointName
        coordinates
        
    end
    methods
        function obj = ImagePoint(img, pnt,x,y)
            if nargin > 0
                obj.imageName = img.ImageID;
                obj.cameraName = img.camera.cameraID;
                obj.pointName = pnt.pointName;
                obj.coordinates  = [x,y];
                
            end
        end
    end
end