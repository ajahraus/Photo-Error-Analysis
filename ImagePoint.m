classdef ImagePoint
    properties
        point
        %         image
        coords
        
    end
    methods
        %         function obj = ImagePoint(img, pnt,imgCoords)
        function obj = ImagePoint(pnt, imgCoords)
            if nargin == 2
                %                 obj.image = img;
                obj.point = pnt;
                obj.coords  = imgCoords;
            end
        end
    end
end