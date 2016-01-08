classdef Camera
    
    properties
        principleDistance
        principlePoint
        sensorArrayPx
        sensorSize
        pixelSize
        cameraID
    end
    
    methods
        function obj = Camera()
%             The camera class is used to hold all of the information about
%             the camera that does not change from image to image,
%             including the principle distance, the principle point, the
%             sensor array size in pixels, the size of the pixels, and the
%             size of the sensor in mm. It also contains an arbirtary ID
%             for the camera, just to be consistent with the rest of the
%             program, and to 
            obj.principleDistance = 24; % mm
            obj.principlePoint = [0,0]; % mm, not that it matters
            obj.sensorArrayPx = [4928,3264]; % pixels, in x then y
            obj.pixelSize = 0.00481; % mm, or 4.81 microns
            obj.sensorSize = obj.sensorArrayPx *obj.pixelSize; % mm
            obj.cameraID = 'cam99';
            
        end
        
    end
    
    
end
