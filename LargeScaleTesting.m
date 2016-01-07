% Photogrammetry Script
close all
clear
clc

tic

%%
planesModel = LoadPlanesFromFile('kuukpak planar model.txt');
points = samplePlanesMulti(planesModel, 5000);

radInc = 360/30;
rads =  [0: radInc : 360-radInc]';
camX = cosd(rads)*7;
camY = sind(rads)*7;
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

toc
%%
for i = 1:length(rads)
    I(i) =  ImageClass(camPos(i,:),angles(i,:),Camera());
end
toc
%%


for i = 1:length(I)
    I(i).imageData = I(i).observePoints(points);
end

toc
%%
for i = 1:5:length(I)
    figure, hold on
    for j = 1:length(I(i).imageData)
        if ~isempty(I(i).imageData(1).coords)
            plot(I(i).imageData(j).coords(1),I(i).imageData(j).coords(2),'.');
        end
    end
    axis equal
    title(['Image ', num2str(i)]);
end

toc