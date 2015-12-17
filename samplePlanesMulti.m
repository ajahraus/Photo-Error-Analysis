function sampledPoints = samplePlanesMulti(allPlanes, totalPoints)
totalArea = 0;
for i = 1:length(allPlanes)
    totalArea = totalArea + allPlanes(i).area;
end
pointsPerArea = totalPoints/totalArea;

sampledPoints = Point(totalPoints);
runningTotal = 0;

for i = 1:length(allPlanes)
    currentPoints = allPlanes(i).samplePlane(round(allPlanes(i).area*pointsPerArea));
    for j = 1:length(currentPoints)
        sampledPoints(runningTotal + j) = currentPoints(j);
    end
    runningTotal = runningTotal + length(currentPoints);
end

end