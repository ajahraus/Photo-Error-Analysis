classdef Plane
    properties
        name
        vertexs
        normal
        centroid
        distance_to_origin
        area
    end
    
    methods
        function obj = Plane(corners)
            if nargin > 0
                obj.vertexs = corners;
                L1 = obj.vertexs(2,:) - obj.vertexs(1,:);
                L2 = obj.vertexs(3,:) - obj.vertexs(1,:);
                
                n = cross(L1,L2);
                obj.normal = n/norm(n);
                
                obj.centroid = mean(corners);
                
                obj.distance_to_origin = abs(dot(obj.normal, obj.vertexs(1,:)));
                
                obj.area = 0.5 * norm( cross(L1,L2) );
                
                obj.name = obj.GenerateRandomPlaneName(4);
            end
        end
        
        function points_class = samplePlane(obj, numPoints)
            % points = obj.samplePlane(numPoints)
            % This function takes an argument of the number of points that
            % the plane is to have sampled from it. The sampling is done in
            % a grid pattern, evenly spaced along the largest axis and
            % sampled orthogonally to it. The number of points in the
            % sample is not exact, so the actual number of points returned
            % may nat exactly correspond to the number of points specified
            % in the input.
            
            point_spacing = sqrt(obj.area/numPoints);
            vert = obj.vertexs;
            v1 = vert(1,:);
            v2 = vert(2,:);
            v3 = vert(3,:);
            
            [~, index] = max( [norm(v2-v1),norm(v3-v1),norm(v3-v2)]);
            if index==1
                base = v1;
                vec1 = v2-base;
                vec2 = v3-base;
            elseif index == 2
                base = v3;
                vec1 = v1-base;
                vec2 = v2-base;
            else
                base = v2;
                vec1 = v3-base;
                vec2 = v1-base;
            end
            
            len = norm(vec1);
            dir = (vec1)/len ;
            
            %             cross_vec = vec2-dot(vec2,dir);
            cross_dir1 = cross(obj.normal, vec1);
            cross_dir = cross_dir1/norm(cross_dir1);
            cross_len = sqrt(norm(vec2)^2 - dot(vec2,dir)^2);
            cross_vec = cross_dir*cross_len;
            
            a= [0:point_spacing:len]';
            linear_samples = [dir(1)*a,dir(2)*a,dir(3)*a]+repmat(base,length(a),1);
            
            numCross = ceil(cross_len/point_spacing);
            all_samples = [];
            
            for i = 0:numCross
                
                new_samples = linear_samples + repmat(cross_dir*point_spacing*i,size(linear_samples,1),1);
                
                all_samples = [all_samples;new_samples];
            end
            
            %             figure, hold on
            % %             plot3([base(1),base(1)+len*dir(1)],[base(2),base(2)+len*dir(2)],[base(3),base(3)+len*dir(3)])
            % %             plot3(linear_samples(:,1),linear_samples(:,2),linear_samples(:,3),'.r')
            %             plot3(all_samples(:,1),all_samples(:,2),all_samples(:,3),'.k')
            %             V = [vert;vert(1,:)];
            %             plot3(V(:,1),V(:,2),V(:,3))
            %             axis equal
            
            v0 = repmat(vec1, size(all_samples,1),1);
            v1 = repmat(vec2, size(all_samples,1),1);
            v2 = all_samples - repmat(base, size(all_samples,1),1);
            dot00 = dot(v0,v0,2);
            dot01 = dot(v0,v1,2);
            dot11 = dot(v1,v1,2);
            dot02 = dot(v0,v2,2);
            dot12 = dot(v1,v2,2);
            
            invDenom = 1./((dot00.*dot11) - (dot01.*dot01));
            u = ((dot11.*dot02)-(dot01.*dot12)).*invDenom;
            v = ((dot00.*dot12)-(dot01.*dot02)).*invDenom;
            
            key1 = u>-0.001;
            key2 = v>-0.001;
            key3 = (u+v)<1.0001;
            
            key = key1.*key2.*key3;
            
            points = deleteRowKey(all_samples,key);
            
            %             V = [vert;vert(1,:)];
            %             figure,hold on
            %             plot3(points(:,1),points(:,2),points(:,3),'r.')
            %             plot3(V(:,1),V(:,2),V(:,3))
            %             axis equal
            %             title('all constraints')
            points_class = Point(size(points,1));
            
            for i = 1:size(points,1)
                points_class(i) = Point(points(i,:),obj);
            end
            
            
        end
    end
    
    methods (Static)
        function name = GenerateRandomPlaneName(lengthOfName)
            
            setOfValidChars = char(['a':'z','0':'9']);
            num = length(setOfValidChars );
            randIndexs =  ceil( num*rand(1,lengthOfName) );
            name = char(zeros(size(1,lengthOfName)));
            
            for i = 1:lengthOfName
                name(i) = setOfValidChars(randIndexs(i));
            end
            name = ['Plane_',name];
        end
    end
end
