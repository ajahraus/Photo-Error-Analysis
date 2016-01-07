clear all
close all
clc

%%
vertices = [0,0,0; 2,0,0; 0, 1, 0;];
cur_plane = Plane(vertices);

points_array = cur_plane.samplePlane(30);

I(1) =  ImageClass([1,-1,3],[25,0,0],Camera());
I(2) = ImageClass([2,0.5,3],[0,25,0],Camera());
I(3) = ImageClass([0,0.5,3],[0,-25,0],Camera());
%%

for i = 1:length(I)
    I(i).imageData = I(i).observePoints(points_array);

%     figure, hold on
%     for j = 1:length(I(i).imageData)
%         if ~isempty(I(i).imageData(1).coords)
%             plot(I(i).imageData(j).coords(1),I(i).imageData(j).coords(2),'.');
%         end
%     end
%     axis equal
%     set(gca,'Xlim',[-I(1).camera.sensorSize(1)/2, I(1).camera.sensorSize(1)/2])
%     set(gca,'Ylim',[-I(1).camera.sensorSize(2)/2, I(1).camera.sensorSize(2)/2])
%     title(['Image Number ',num2str(i)])
end

%%
createPHOfile('SimulationOne.pho',I)
createINPfile('SimulationOne.inp',I,points_array)