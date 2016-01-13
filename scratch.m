% Photogrammetry Script
close all
clear
clc


%%
% tic
plane1 = Plane([0,0,0;2,0,0;0,1,0]);
points = samplePlanesMulti(plane1, 50);
newpoint = Point(points(round(length(points)/2)).xyz - [0,0,0.0001]);
points = [points,newpoint];

radInc = 360/6;
rads =  [0: radInc : 360-radInc]';
camX = cosd(rads)*1.5;
camY = sind(rads)*1.5;
camZ = ones(size(camX));
camPos = [camX+1, camY+0.5,camZ+1];

fig = 0;
if fig
    figure, hold on
    for i = 1:length(points)
        plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
    end
    axis equal
end

angles = zeros(size(rads,1),3);
for i = 1:length(angles)
    Zvec = [camX(i), camY(i), camZ(i)+3]';
    Zvec = Zvec/ sqrt(sum(Zvec.^2));
    
    Xvec = [-Zvec(2), Zvec(1), 0]';
    Xvec = Xvec/ sqrt(sum(Xvec.^2));
    
    Yvec = cross(Zvec, Xvec);
    
    R = [Xvec, Yvec, Zvec]';
    angles(i,:) = [atan2d(-R(3,2),R(3,3)),asind(R(3,1)),atan2d(-R(2,1), R(1,1))];
    if fig
        plot3(camPos(i,1),camPos(i,2),camPos(i,3),'.r')
        quiver3(camPos(i,1),camPos(i,2),camPos(i,3),Zvec(1),Zvec(2),Zvec(3),0,'b')
        quiver3(camPos(i,1),camPos(i,2),camPos(i,3),Xvec(1),Xvec(2),Xvec(3),0,'r')
        quiver3(camPos(i,1),camPos(i,2),camPos(i,3),Yvec(1),Yvec(2),Yvec(3),0,'g')
    end
end

% toc
%%
% tic
for i = 1:length(rads)
    I(i) =  ImageClass(camPos(i,:),angles(i,:),Camera());
end
% toc
%%
% tic

for i = 1:length(I)
    I(i).imageData = I(i).observePoints(points);
end

% toc
%%
tic
c = I(1).camera.principleDistance;
for i = 1:length(points)
    % For each element in the poinst array, check if it has more than two
    % observations. If it does, procede. 
    if points(i).numObs >= 2
        % save the current points' ID for quicker access later on
        currentPointID = points(i).pointName;
        
        % Pre-allocate memory for the cost and indexes of the image pairs
        listOfImagePairs = zeros(round((points(i).numObs * (points(i).numObs-1))/2),3);
        % Since the index of the next point can be hard to predict, save
        % the index here and increment it later, once the next image pair
        % has been assigned.
        nextIndex = 1;
        
        % For each image ID in the list of image IDs, except for the last
        % one, for the current element in the points array:
        for j = 1:size(points(i).imgNames,1)-1
            
            % Check to find the index of the image which has the ID that
            % matches the the current imageID in the current point' list of
            % image IDs
            flag = 0;
            for n = 1:length(I)
                if strcmp(I(n).ImageID, points(i).imgNames(j,:))
                    imgIdx1 = n;
                    flag = 1;
                    break;
                end
            end
            % Throw a warning if that image was not found
            if flag == 0
                warning(['No element in points(',num2str(i),').imgNames'...
                    ,' matches I.ImageID,first set']);
            end
            
            % Starting at the element after, find the index of the second
            % image ID
            for k = j+1:size(points(i).imgNames,1)
                
                % Find the indexs of the second image of the listed image
                % pair
                flag = 0;
                for m = 1:length(I)
                    if strcmp(I(m).ImageID, points(i).imgNames(k,:))
                        imgIdx2 = m;
                        flag = 1;
                        break;
                    end
                end
                % again, throw a warning if it is not found
                if flag == 0
                    warning(['No element in points(',num2str(i),').imgNames'...
                        ,' matches I.ImageID, second set']);
                end
                
                % Once both images have been identified, begin calculating
                % the cost of this configuration. 
                
                % calulate the angle between the image point observation
                % and the principle point. Ideally, it is close to zero, so
                % the cost associated with larger angles here corresponds
                % to the sin of the angle
                alpha = 2;
                for x = 1:length(I(imgIdx1).imageData)
                    if strcmp(I(imgIdx1).imageData(x).point.pointName, currentPointID)
                        alpha = acos( norm(I(imgIdx1).imageData(x).coords) / c );
                        break;
                    end
                end
                
                % display a warning if the point was not found in the image
                % list of points
                if alpha == 2
                    warning([currentPointID,' not found in the list of point in Image ',imgIdx1]);
                end
                
                % same as before, using the second image
                beta = 2;
                for x = 1:length(I(imgIdx2).imageData)
                    if strcmp(I(imgIdx2).imageData(x).point.pointName, currentPointID)
                        beta = acos( norm(I(imgIdx2).imageData(x).coords) / c );
                        break;
                    end
                end
                
                if beta == 2
                    warning([currentPointID,' not found in the list of point in Image ',imgIdx2]);
                end
                
                % The final cost value corresponds to the cosine of the
                % angle of intesection of the two image centers and the
                % object point in question(i.e. the closer to 90 the
                % better). Since the dot product of the two vectors already
                % corresponds to the cosine of that angle, it is not 
                % necessary to calculate the angle. 
                vec1 = I(imgIdx1).location - points(i).xyz;
                vec1 = vec1/norm(vec1);
                
                vec2 = I(imgIdx2).location - points(i).xyz;
                vec2 = vec2/norm(vec2);
                
                cost = dot(vec1,vec2)^2 + sin(alpha)^2 + sin(beta)^2;
                
                % save the cost 
                listOfImagePairs(nextIndex,:) = [ cost, imgIdx1, imgIdx2];
                nextIndex = nextIndex + 1;
            end
        end
        
        for j = 1:size(listOfImagePairs,1)
            if listOfImagePairs(j,:) == [0,0,0];
                listOfImagePairs(j,:) = [4,-1,-1];
            end
        end
        
        sortedImagePairs = sortrows(listOfImagePairs);
        
        indexesToPreserve = sort(sortedImagePairs(1,2:3));
        
        
        for z = 1:length(I)
            
            if z ~= indexesToPreserve(1) && z ~= indexesToPreserve(2)
                correctIndex = -1;
                for f = 1:length(I(z).imageData)
                    if strcmp(I(z).imageData(f).point.pointName, currentPointID)
                        correctIndex = f;
                        break;
                    end
                end
                
                if correctIndex > 0
                    I(z).imageData(correctIndex) = [];
                else
                    % If we get to this point, it means that this image
                    % hasn't taken an image of this point. To verify, we
                    % can compare the ID of the current image to the list
                    % of image IDs for this point. We only need to worry if
                    % there is a match.
                    flag = 1;
                    for k = 1:size(points(i).imgNames,1)
                        if strcmp(I(z).ImageID, points(i).imgNames(k,:))
                            flag = 0;
                            break;
                        end
                    end
                    
                    if flag == 0
                        error(001,'Mis-match between ImageID list of point observations')
                    end
                end
                
            end
        end

        points(i).imgNames = [I(indexesToPreserve(1)).ImageID;...
            I(indexesToPreserve(2)).ImageID;];
        points(i).numObs = size(points(i).imgNames,1);
        
    end
end
toc

%%
allPointNames = [];
for i = 1:length(I)
    for j = 1:length(I(i).imageData)
        currentString = I(i).imageData(j).point.pointName;
        allPointNames = [allPointNames; currentString];
    end
end
% There doesn't seem to be any duplicate points in this list, but it does
% seem like there are solitary points. I suppose that they may have been
% there before this process begain. I.e. there are a set of points which
% have only one observation. I should account for those, before doing this
% list.
%%
allPointNames = sortrows(allPointNames);
non_duplicates = allPointNames;
i = 1;
while i < size(non_duplicates, 1)
    if strcmp(non_duplicates(i,:), non_duplicates(i+1,:))
        non_duplicates(i:i+1,:) = [];
    else
        i = i+1;
    end
end

j = 0;
for i = 1:length(points)
    if points(i).numObs > 2
        j = j+1;
    end
end

if j ~= size(non_duplicates,1)
    warning(['The number of point that appear in a single point does not correspond to the \n'...
        ,'actual number of points that appear in a single image']);
end

