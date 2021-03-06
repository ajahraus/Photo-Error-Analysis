% Photogrammetry Script
close all
clear
clc


%%
% Creating Points to be imaged
% plane1 = Plane([0,0,0;2,0,0;0,1,0]);
% points = samplePlanesMulti(plane1, 100);
% newpoint = Point(points(round(length(points)/2)).xyz - [0,0,0.0001]);
% points = [points,newpoint];
radIncPoints=  360/30;
horzAng = [0:radIncPoints:360-radIncPoints]';
vertAng = [0:radIncPoints:90-radIncPoints]';
pointsArray = [];
for i = 1:length(vertAng)
    xpoints = cosd(horzAng)*cosd(vertAng(i));
    ypoints = sind(horzAng)*cosd(vertAng(i));
    zpoints = repmat( sind(vertAng(i)), size(xpoints,1),1);
    pointsArray = [pointsArray; xpoints, ypoints, zpoints];
end
pointsArray = [pointsArray; 0, 0, 1];

points = Point();
for i = 1:length(pointsArray)
    points(i) = Point(pointsArray(i,:));
end
%%
% Creating images
radInc = 360/6;
rads =  [0: radInc : 360-radInc]';
camX = cosd(rads)*2;
camY = sind(rads)*2;
camZ = ones(size(camX));
camPos = [camX, camY,camZ+1];

fig = 1;
if fig
    figure, hold on
    for i = 1:length(points)
        plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
    end
    axis equal
end

angles = zeros(size(rads,1),3);
for i = 1:length(angles)
    Zvec = [camX(i), camY(i), camZ(i)+0.5]';
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
I = reducePointObs(I,points);
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

%%
createFEMBUNfiles('smallTest2',I,points);

%%
for i = 1:1:length(I)
    figure, hold on
    for j = 1:length(I(i).imageData)
        if ~isempty(I(i).imageData(1).coords)
            plot(I(i).imageData(j).coords(1),I(i).imageData(j).coords(2),'.');
        end
    end
    set(gca,'xlim',[-I(1).camera.sensorSize(1)/2,I(1).camera.sensorSize(1)/2]);
    set(gca,'ylim',[-I(1).camera.sensorSize(2)/2,I(1).camera.sensorSize(2)/2]);
    title(['Image ', num2str(i)]);
end

fclose('all');