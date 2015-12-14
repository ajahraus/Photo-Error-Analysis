% Photogrammetry Script

close all
clear all
clc

%% 
I(1) =  ImageClass([0,0,0],[90,225,0],Camera());
I(2) =  ImageClass([0,1,0],[90,315,0],Camera());

I(1).displayImageInObjectSpace(1);
I(2).displayImageInObjectSpace(1);

plane1 = Plane(eye(3)-repmat([1,0,0.5],3,1));
points = plane1.samplePlane(100);

points2 = [-0.55,0.45,0; 0+sqrt(2)/10,1+sqrt(2)/10,0;-0.55,0.45005,0;];
for i = 1:size(points2,1)
    points(end+1) = Point(points2(i,:));
end

for i = 1:length(points)
    plot3(points(i).xyz(1,1),points(i).xyz(1,2),points(i).xyz(1,3),'.')
end
axis equal

%%
img_points_1 = I(1).observePoints(points)
img_points_2 = I(2).observePoints(points)
