classdef ImageClass
    properties
        location
        direction
        imageData
        camera
        ImageID
    end
    
    methods
        function obj = ImageClass(loc, dir, cam)
            if nargin > 0
                % location = meters
                % direction = degrees when entering, stored and mathed with rads
                % cam can be Camera()
                obj.location = loc;
                obj.direction = dir*pi/180;
                obj.camera = cam;
                
                % Something should be done here to ensure uniqueness
                obj.ImageID = obj.GenerateRandomImageName(6);
                
                % This also needs to relate to the planar models. Probably
                % appropriate to create its own function, though.
                obj.imageData = [];
            end
        end
        
        function displayImageInObjectSpace(obj,varparam)
            if varparam ~= 1
                figure;
            end
            hold on
            loc = obj.location;
            M =0.05* rotz(obj.direction(3))*roty(pi+obj.direction(2))*rotx(obj.direction(1));
            
            quiver3(loc(1),loc(2),loc(3),M(1,1),M(1,2),M(1,3),0,'r')
            quiver3(loc(1),loc(2),loc(3),M(2,1),M(2,2),M(2,3),0,'g')
            quiver3(loc(1),loc(2),loc(3),M(3,1),M(3,2),M(3,3),0,'b')
            axis equal
            
            LOC = repmat(loc,4,1);
            width = obj.camera.sensorSize/2;
            CORNERS = (1/24)*[width(1),width(2),obj.camera.principleDistance;
                -width(1),width(2),obj.camera.principleDistance;
                -width(1),-width(2),obj.camera.principleDistance;
                width(1),-width(2),obj.camera.principleDistance;]*M;
            
            quiver3(LOC(:,1),LOC(:,2),LOC(:,3),CORNERS(:,1),CORNERS(:,2),CORNERS(:,3),0,'k')
            plot3(loc(1),loc(2),loc(3),'.k')
            
            
        end
        
        function imagePoints = observePoints(obj, points)
            
            if ~isa(points,'Point')
                temp = Point(size(points,1));
                for i = 1:size(points,1)
                    temp(i) = points(i,:);
                end
                points = temp;
            end
            
            c = obj.camera.principleDistance;
            M = rotz(obj.direction(3))*roty(obj.direction(2))*rotx(obj.direction(1));
            X_0 = obj.location(1);
            Y_0 = obj.location(2);
            Z_0 = obj.location(3);
            
            img_x = zeros(length(points),1);
            img_y = img_x;
            
            key3  = ones(size(img_y));
            for i = 1:length(points)
                X = points(i).xyz(1);
                Y = points(i).xyz(2);
                Z = points(i).xyz(3);
                localVec = M*[X-X_0;Y-Y_0;Z-Z_0];
                
                if localVec(3) < 0
                    key3(i) = 0;
                end
                
                img_x(i) = round((-c*localVec(1)/localVec(3))/obj.camera.pixelSize)*obj.camera.pixelSize;
                img_y(i) = round((-c*localVec(2)/localVec(3))/obj.camera.pixelSize)*obj.camera.pixelSize;
                
            end
            
            key1 = abs(img_x) < obj.camera.sensorSize(1)/2;
            key2 = abs(img_y) < obj.camera.sensorSize(2)/2;
            
            imagePoints = deleteRowKey([img_x, img_y], key1.*key2.*key3);
            
        end
    end
    
    methods (Static)
        function name = GenerateRandomImageName(lengthOfName)
            
            setOfValidChars = char(['a':'z','0':'9']);
            num = length(setOfValidChars );
            randIndexs =  ceil( num*rand(1,lengthOfName) );
            name = char(zeros(size(1,lengthOfName)));
            
            for i = 1:lengthOfName
                name(i) = setOfValidChars(randIndexs(i));
            end
            name = ['Image_',name];
        end
    end
end