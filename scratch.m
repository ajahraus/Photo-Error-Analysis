% Photogrammetry Script

close all
clear 
clc

%% 
I(1) =  ImageClass([0,0,0],[90,45,-45],Camera());
I(2) =  ImageClass([0,1,0],[90,135,45],Camera());
I(3) = ImageClass([0,0.5,0],[90,90,0],Camera());

I(1).displayImageInObjectSpace(1);
I(2).displayImageInObjectSpace(1);
I(3).displayImageInObjectSpace(1);

plane1 = Plane(eye(3)-repmat([1,0,0.5],3,1));
points = plane1.samplePlane(100);

for i = 1:length(points)
    plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
end
axis equal

%%

img_points1 = I(1).observePoints(points);
img_points2 = I(2).observePoints(points);
img_points3 = I(3).observePoints(points);

img_points = [img_points1, img_points2, img_points3];

figure, hold on
for i = 1:length(img_points3)
    plot(img_points3(i).coords(1,1),img_points3(i).coords(1,2),'.');
end
