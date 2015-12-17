% Photogrammetry Script

close all
clear 
clc

%% 
I(1) =  ImageClass([0,0,10],[0,0,0],Camera());
I(2) =  ImageClass([0,1,10],[0,45,90],Camera());


planesModel = LoadPlanesFromFile('kuukpak planar model.txt');

tic
points = samplePlanesMulti(planesModel, 10000);
toc

for i = 1:length(I)
    I(i).displayImageInObjectSpace(1);
end

for i = 1:length(points)
    plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
end
axis equal

%%

img_points{1} = I(1).observePoints(points);
img_points{2} = I(2).observePoints(points);

for i = 1:length(img_points)
    colour = rand(3,1);
    figure, hold on
    for j = 1:length(img_points{i})
        plot(img_points{i}(j).coords(1,1),img_points{i}(j).coords(1,2),'.','Color',colour);
    end
    axis equal
end
