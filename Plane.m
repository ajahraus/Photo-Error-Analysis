classdef Plane
    properties
        vertexs
        normal
        centroid
        distance_to_origin
        area
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

                obj.area = 0.5 * norm( cross(L1,L2) );
            end
        end
        
        
        function points = samplePlane(obj, numPoints)
            % Needs some improvement
            points = zeros(size(numPoints),3);
            
            point_spacing = sqrt(numPoints/obj.area);
            v = obj.vertexs;
            v1 = v(1,:);
            v2 = v(2,:);
            v3 = v(3,:);
            
            [~, index] = max( [norm(v2-v1),norm(v3-v1),norm(v3-v2)]);
            if index==1
                base = v1;
                dir = (v2-v1)/norm(v2-v1);
                cross_dir = cross(obj.normal,dir);
            elseif index == 2
                base = v1;
                dir = (v3-v1)/norm(v3-v1);
                cross_dir = cross(obj.normal,dir);
            else
                base = v2;
                dir = (v3-v2)/norm(v3-v2);
                cross_dir = cross(obj.normal,dir);
            end
            
                
        end
    end
    
    methods (Static)
        
    end
    
end
