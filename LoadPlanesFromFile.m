function planes = LoadPlanesFromFile(filename)

rawdata = load(filename,'ascii');

numPlanes = size(rawdata,1)/3;

 for i = 1:numPlanes
     planes(i) = Plane(rawdata(((3*(i - 1))+1):(3*(i - 1))+3,:));
 end
