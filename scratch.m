% Photogrammetry Script

close all
clear all
clc

%% 
I(1) =  ImageClass([0,0,0],[90,225,0],Camera());
I(2) =  ImageClass([0,1,0],[90,315,0],Camera());

I(1).displayImageInObjectSpace(1);
I(2).displayImageInObjectSpace(1);

point = [-0.55,0.45,0; 1000,1000,1000;-0.55,0.45005,0;];
plot3(point(1),point(2),point(3),'.')
axis equal

%%
img_points_1 = I(1).observePoints(point)
img_points_2 = I(2).observePoints(point)

img_points_1/I(1).camera.pixelSize
