classdef Plane
    properties
        vertexs
        normal
        centroid
        distance_to_origin
    end
    
    methods
        function obj = Plane(corners)
            if nargin ~= 0
                obj.vertexs = corners;
                L1 = obj.vertexs(2,:) - obj.vertexs(1,:);
                L2 = obj.vertexs(3,:) - obj.vertexs(1,:);
                
                n = cross(L1,L2);
                obj.normal = n/norm(n);
                
                obj.centroid = mean(corners);
                
                obj.distance_to_origin = abs(dot(obj.normal, obj.vertexs(1,:)));
            
            end
        end
    end
    
end
