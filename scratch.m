% Photogrammetry Script

close all
clear 
clc

%% 

radInc =  [0: (360/60 *pi/180) : 4*pi]';
camX = cos(radInc)*6;
camY = sin(radInc)*6;
camZ = ones(size(camX));
camPos = [camX, camY+3,camZ];

for i = 1:length(radInc)
    if i <= 61
        I(i) =  ImageClass(camPos(i,:),[90,90+180/pi*atan2(camY(i),camX(i)),0],Camera());
    else
        I(i) =  ImageClass(camPos(i,:),[90,90+180/pi*atan2(camY(i),camX(i)),90],Camera());
    end
end

planesModel = LoadPlanesFromFile('kuukpak planar model.txt');

tic
points = samplePlanesMulti(planesModel, 5000);
toc

for i = 1:length(I)
    I(i).displayImageInObjectSpace(1);
end

for i = 1:length(points)
    plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
end
axis equal

%%
img_points = cell(length(I),1);
for i = 1:length(I)
    img_points{i} = I(i).observePoints(points);
end

%%

for i = 1:20:length(img_points)
    figure, hold on
    for j = 1:length(img_points{i})
        if ~isempty(img_points{i}(1).coords)
            plot(img_points{i}(j).coords(1),img_points{i}(j).coords(2),'.');
        end
    end
    axis equal
    title(['Image ', num2str(i)]);
end
