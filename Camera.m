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
            
            obj.principleDistance = 24; % mm
            obj.principlePoint = [0,0]; % mm, not that it matters
            obj.sensorArrayPx = [4928,3264]; % pixels, in x then y
            obj.pixelSize = 0.00481; % mm, or 4.81 microns
            obj.sensorSize = obj.sensorArrayPx *obj.pixelSize; % mm
            obj.cameraID = 99;
            
        end
        
    end
    
    
end
