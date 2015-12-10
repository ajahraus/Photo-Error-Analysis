classdef Camera

    properties
        principleDistance
        principlePoint
        sensorArrayPx
        sensorSize
        pixelSize
    end
    
    methods 
        function obj = Camera()
            obj.principleDistance = 24; % mm
            obj.principlePoint = [0,0]; % mm, not that it matters
            obj.sensorArrayPx = [3264,4928]; % pixels, in rows then coloumns
            obj.pixelSize = 0.00481; % mm, or 4.81 microns
            obj.sensorSize = obj.sensorArrayPx *obj.pixelSize; % mm
            
        end
        
    end
end
