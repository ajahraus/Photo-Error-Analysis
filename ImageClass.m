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
            M =0.05* rotz(obj.direction(3))*roty(obj.direction(2))*rotx(obj.direction(1));
            
            quiver3(loc(1),loc(2),loc(3),M(1,1),M(1,2),M(1,3),0,'r')
            quiver3(loc(1),loc(2),loc(3),M(2,1),M(2,2),M(2,3),0,'g')
            quiver3(loc(1),loc(2),loc(3),M(3,1),M(3,2),M(3,3),0,'b')
            axis equal
            
            LOC = repmat(loc,4,1);
            width = obj.camera.sensorSize/2;
            CORNERS = (1/24)*[width(1),width(2),-obj.camera.principleDistance;
                -width(1),width(2),-obj.camera.principleDistance;
                -width(1),-width(2),-obj.camera.principleDistance;
                width(1),-width(2),-obj.camera.principleDistance;]*M;
            
            quiver3(LOC(:,1),LOC(:,2),LOC(:,3),CORNERS(:,1),CORNERS(:,2),CORNERS(:,3),0,'k')
            plot3(loc(1),loc(2),loc(3),'.k')
            
            
        end
        
        function FinalImageObs = observePoints(obj, points)
            
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
            
            
            imageObs = ImagePoint();
            
            flag = 1;
            for i = 1:length(points)
                X = points(i).xyz(1);
                Y = points(i).xyz(2);
                Z = points(i).xyz(3);
                localVec = M*[X-X_0;Y-Y_0;Z-Z_0];
                
                img_x = round((-c*localVec(1)/localVec(3))/obj.camera.pixelSize)*obj.camera.pixelSize;
                img_y = round((-c*localVec(2)/localVec(3))/obj.camera.pixelSize)*obj.camera.pixelSize;
                
                if abs(img_x) < obj.camera.sensorSize(1)/2 & abs(img_y) < obj.camera.sensorSize(2)/2 & localVec(3)<0
                    if flag == 1
                        flag = 0;
                        imageObs = ImagePoint(points(i),[img_x,img_y]);
                        points(i).numObs = points(i).numObs  + 1;
                    else
                        imageObs(end+1) = ImagePoint(points(i),[img_x,img_y]);
                        points(i).numObs = points(i).numObs  + 1;
                    end
                end
            end
            
            FinalImageObs = obj.deleteNonUniqueImageCoords(imageObs);
        end
        
        function FinalImagePoints = deleteNonUniqueImageCoords(obj, imageObs)
            % TODO: reduce number of observations in the points array
            pnts = zeros(size(imageObs,2),2);
            rangeToPnt = zeros(length(imageObs),1);
            
            M = rotz(obj.direction(3))*roty(obj.direction(2))*rotx(obj.direction(1));
            X_0 = obj.location(1);
            Y_0 = obj.location(2);
            Z_0 = obj.location(3);
            
            if ~isempty(imageObs(1).point)
                for i = 1:length(imageObs)
                    X = imageObs(i).point.xyz(1);
                    Y = imageObs(i).point.xyz(2);
                    Z = imageObs(i).point.xyz(3);
                    
                    localVec = M*[X-X_0;Y-Y_0;Z-Z_0];
                    
                    rangeToPnt(i) = abs(localVec(3));
                end
                
                
                for i = 1:size(imageObs,2)
                    pnts(i,:) = imageObs(i).coords;
                end
                
                roundedPnts = round(pnts/obj.camera.pixelSize);
                rPntsIndex = [roundedPnts, (1:size(roundedPnts,1))'];
                
                testPoints = sortrows(rPntsIndex);
                indexes = [];
                
                for i = 2:length(roundedPnts)
                    if (testPoints(i-1,1) == testPoints(i,1))&(testPoints(i-1,2) == testPoints(i,2))
                        indexes = [indexes;testPoints(i-1,3),testPoints(i,3)];
                    end
                end
                
                indexesToSkip = [];
                for i = 1:size(indexes,1)
                    if strcmp(imageObs(indexes(i,1)).point.planeName, imageObs(indexes(i,2)).point.planeName) & ~isempty(imageObs(indexes(i,1)).point.planeName)
                        % Take the index with the name that comes first,
                        % alphabetically
                        multi = (2^length(imageObs(indexes(i,1)).point.planeName))./(2.^[1:length(imageObs(indexes(i,1)).point.planeName)]);
                        vals1 = (imageObs(indexes(i,1)).point.planeName > imageObs(indexes(i,2)).point.planeName).*multi;
                        vals2 = (imageObs(indexes(i,1)).point.planeName < imageObs(indexes(i,2)).point.planeName).*multi;
                        
                        sum1 = sum(vals1);
                        sum2 = sum(vals2);
                        
                        if sum1 > sum2
                            indexesToSkip = [indexesToSkip,indexes(i,2)];
                        else
                            indexesToSkip = [indexesToSkip,indexes(i,1)];
                        end
                        
                    else
                        % Take the index with the lower range to the camera
                        if rangeToPnt(indexes(i,1)) > rangeToPnt(indexes(i,2))
                            indexesToSkip = [indexesToSkip,indexes(i,1)];
                        else
                            indexesToSkip = [indexesToSkip,indexes(i,2)];
                        end
                    end
                end
            else
                indexesToSkip = [];
            end
            
            flag = 1;
            if isempty(indexesToSkip)
                FinalImagePoints = imageObs;
            else
                FinalImagePoints = ImagePoint();
                for i = 1:length(imageObs)
                    copy = 1;
                    for j = 1:length(indexesToSkip)
                        if i == indexesToSkip(j)
                            copy = 0;
                        end
                    end
                    
                    if copy == 1
                        if flag == 1
                            FinalImagePoints = imageObs(i);
                            flag = 0;
                        else
                            FinalImagePoints(end+1) = imageObs(i);
                        end
                    end
                    
                end
            end
            
            
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
            name = ['I',name];
        end
    end
end