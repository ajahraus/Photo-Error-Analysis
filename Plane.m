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
        
        
        function points = samplePlane(obj, numPoints)
            % Needs some improvement
            points = zeros(numPoints,3);
            v = obj.vertexs;
            
            L1 = norm(v(2,:) - v(1,:));
            L2 = norm(v(3,:) - v(1,:));
            L3 = norm(v(3,:) - v(2,:));
            
            temp = sortrows([L1, v(2,:)-v(1,:),12; L2, v(3,:) - v(1,:),13; L3, v(3,:) - v(2,:),23]);
            
            Longest_vector = temp(3, 2:4);
            Second_vector = temp(2, 2:4);
            
            
            
        end
    end
    
    methods (Static)
        
    end
    
end
