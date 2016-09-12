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
                        points(i).imgNames = [points(i).imgNames; obj.ImageID];
                    else
                        imageObs(end+1) = ImagePoint(points(i),[img_x,img_y]);
                        points(i).numObs = points(i).numObs  + 1;
                        points(i).imgNames = [points(i).imgNames; obj.ImageID];
                    end
                end
            end
            
            FinalImageObs = obj.deleteNonUniqueImageCoords(imageObs, points);
        end
        
        function FinalImagePoints = deleteNonUniqueImageCoords(obj, imageObs, points)
            % This name is outdated, it delets Non Unique image Coordinates
            % but it also reduces the number of observations to each point
            % to only two images.
            
            % declare point observation array and range to point arrays
            pnts = zeros(size(imageObs,2),2);
            rangeToPnt = zeros(length(imageObs),1);
            
            % localize EOPs
            M = rotz(obj.direction(3))*roty(obj.direction(2))*rotx(obj.direction(1));
            X_0 = obj.location(1);
            Y_0 = obj.location(2);
            Z_0 = obj.location(3);
            
            % check if image obs is empty
            if ~isempty(imageObs(1).point)
                for i = 1:length(imageObs)
                    % localize point locations
                    X = imageObs(i).point.xyz(1);
                    Y = imageObs(i).point.xyz(2);
                    Z = imageObs(i).point.xyz(3);
                    
                    localVec = M*[X-X_0;Y-Y_0;Z-Z_0];
                    
                    % calculate range to point in local system
                    rangeToPnt(i) = abs(localVec(3));
                end
                
                % load image obs into local points array
                for i = 1:size(imageObs,2)
                    pnts(i,:) = imageObs(i).coords;
                end
                
                % round image obs to pixel coords (i.e. whole numbers)
                roundedPnts = round(pnts/obj.camera.pixelSize);
                % add index number to vector
                rPntsIndex = [roundedPnts, (1:size(roundedPnts,1))'];
                
                % sorting image obs to find matches
                testPoints = sortrows(rPntsIndex);
                indexes = [];
                
                % loading indexes of points that match their previous row
                % into vector of indexes
                for i = 2:length(roundedPnts)
                    if (testPoints(i-1,1) == testPoints(i,1))&(testPoints(i-1,2) == testPoints(i,2))
                        indexes = [indexes;testPoints(i-1,3),testPoints(i,3)];
                    end
                end
                
                % Determining which of the matching points should be
                % deleted. If the points come from the same plane, then
                % the point with the id that comes first alphatetically
                % should be used (to maximize redundancy). Otherwise, the
                % point that is located closer to the camera should be
                % used.
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
                            
                            % check all points in the points array. The one
                            % which has a matching name to the point in the
                            % imageObs class has its observation number
                            % reduced by one.
                            for j = 1:length(points)
                                if strcmp(points(j).pointName, imageObs(indexes(i,2)).point.pointName)
                                    for k = 1:size(points(j).imgNames,1)
                                        if strcmp(points(j).imgNames(k,:), obj.ImageID)
                                            points(j).imgNames(k,:) = [];
                                            points(j).numObs = points(j).numObs - 1;
                                            break;
                                        end
                                    end
                                end
                            end
                        else
                            indexesToSkip = [indexesToSkip,indexes(i,1)];
                            for j = 1:length(points)
                                if strcmp(points(j).pointName, imageObs(indexes(i,1)).point.pointName)
                                    
                                    for k = 1:size(points(j).imgNames,1)
                                        if strcmp(points(j).imgNames(k,:), obj.ImageID)
                                            points(j).imgNames(k,:) = [];
                                            points(j).numObs = points(j).numObs - 1;
                                            break;
                                        end
                                    end
                                end
                            end
                        end
                    else
                        % Take the index with the lower range to the camera
                        if rangeToPnt(indexes(i,1)) > rangeToPnt(indexes(i,2))
                            indexesToSkip = [indexesToSkip,indexes(i,1)];
                            for j = 1:length(points)
                                if strcmp(points(j).pointName, imageObs(indexes(i,1)).point.pointName)
                                    
                                    for k = 1:size(points(j).imgNames,1)
                                        if strcmp(points(j).imgNames(k,:), obj.ImageID)
                                            points(j).imgNames(k,:) = [];
                                            points(j).numObs = points(j).numObs - 1;
                                            break;
                                        end
                                    end
                                end
                            end
                        else
                            indexesToSkip = [indexesToSkip,indexes(i,2)];
                            for j = 1:length(points)
                                if strcmp(points(j).pointName, imageObs(indexes(i,2)).point.pointName)
                                    
                                    for k = 1:size(points(j).imgNames,1)
                                        if strcmp(points(j).imgNames(k,:), obj.ImageID)
                                            points(j).imgNames(k,:) = [];
                                            points(j).numObs = points(j).numObs - 1;
                                            break;
                                        end
                                    end
                                end
                            end
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
            
            for i = 1:length(points)
                if points(i).numObs ~= size(points(i).imgNames,1)
                    error(['Point number ', num2str(i),' has mismatched observation number, ImageIDs. ImageID: ',obj.ImageID]);
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