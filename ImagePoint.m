classdef ImagePoint
    properties
        image
        point
        coords
        
    end
    methods
        function obj = ImagePoint(img, pnt,imgCoords)
            if nargin > 0
                obj.image = img;
                obj.point = pnt;
                obj.coords  = imgCoords;
                
            end
        end
    end
end