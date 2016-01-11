function newImages = reducePointObs(Images, points)

% for each image observation, add an observation to the point. If that
% number is less than two, eliminate both that point from the list of
% points, and from the image observations (if it exists)
newImages = Images;
for k = 1:length(points)
    if points(k).numObs < 2
        pntName = points(k).pointName;
        
        for i = 1:length(newImages)
            for j = 1:length(Images(i).imageData)
                if strcmp(pntName, newImages(i).imageData(j).point.pointName)
                    if j ~= 0 && j ~= length(newImages(i).imageData)
                        newImages(i).imageData = newImages(i).imageData(1:j-1,j+1);
                        break;
                    elseif j == 0
                        newImages(i).imageData = newImages(i).imageData(2:end);
                        break;
                    elseif j == length(newImages(i).imageData)
                        newImages(i).imageData = newImages(i).imageData(1:end-1);
                        break;
                    end
                    
                end
            end
        end
    elseif point(k).numObs > 2
        % The pair of cameras that have approximately equal convergence
        % angle on the point are the two that will keep their observations.
        
    end
end