% Photogrammetry Script
close all
clear
clc


%%
% tic
planesModel = LoadPlanesFromFile('kuukpak planar model.txt');
points = samplePlanesMulti(planesModel, 500);

radInc = 360/20;
rads =  [0: radInc : 360-radInc]';
camX = cosd(rads)*12;
camY = sind(rads)*12;
camZ = ones(size(camX));
camPos = [camX, camY+3,camZ+1];

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
tic

for i = 1:length(I)
    I(i).imageData = I(i).observePoints(points);
end

toc
%%
tic
c = I(1).camera.principleDistance;
for i = length(points)-1:length(points)
    
    currentPointID = points(i).pointName;
    listOfImagePairs = zeros(round((points(i).numObs * (points(i).numObs-1))/2),3);
    nextIndex = 1;
    
    for j = 1:size(points(i).imgNames,1)-1
        for n = 1:length(I)
            if strcmp(I(n).ImageID, points(i).imgNames(j,:))
                imgIdx1 = n;
                break;
            end
        end
        
        for k = j+1:size(points(i).imgNames,1)
            for m = 1:length(I)
                if strcmp(I(m).ImageID, points(i).imgNames(k,:))
                    imgIdx2 = m;
                    break;
                end
            end
            
            alpha = 1;
            for x = 1:length(I(imgIdx1).imageData)
                if strcmp(I(imgIdx1).imageData(x).point.pointName, currentPointID)
                    alpha = acos( norm(I(imgIdx1).imageData(x).coords) / c );
                    break;
                end
            end
            
            beta = 1;
            for x = 1:length(I(imgIdx2).imageData)
                if strcmp(I(imgIdx2).imageData(x).point.pointName, currentPointID)
                    beta = acos( norm(I(imgIdx2).imageData(x).coords) / c );
                    break;
                end
            end
            
            vec1 = I(imgIdx1).location - points(i).xyz;
            vec1 = vec1/norm(vec1);
            
            vec2 = I(imgIdx2).location - points(i).xyz;
            vec2 = vec2/norm(vec2);
            
            cost = dot(vec1,vec2)^2 + sin(alpha)^2 + sin(beta)^2;
            
            
            listOfImagePairs(nextIndex,:) = [ cost, j, k];
            nextIndex = nextIndex + 1;
        end
    end
    
    sortedImagePairs = sortrows(listOfImagePairs);
    
    indexesToPreserve = sort(sortedImagePairs(1,2:3));
    
    for z = 1:length(I)
        
        if z ~= indexesToPreserve(1) && z ~= indexesToPreserve(2)
            
            for f = 1:length(I(z).imageData)
                if strcmp(I(z).imageData(f).point.pointName, currentPointID)
                    correctIndex = f;
                    break;
                end
            end
            
            if correctIndex ~= 1 && correctIndex ~= length(I(z).imageData)
                I(z).imageData = I(z).imageData([1:correctIndex-1, correctIndex+1:end]);
            elseif correctIndex == 1
                I(z).imageData = I(z).imageData(2:end);
            elseif correctIndex == length(I(z).imageData)
                I(z).imageData = I(z).imageData(1:end-1);
            end
            
        end
    end
    
end
toc