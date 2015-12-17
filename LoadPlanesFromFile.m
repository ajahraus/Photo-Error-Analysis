function planes = LoadPlanesFromFile(filename)

rawdata = load(filename,'ascii');

numPlanes = size(rawdata,1)/3;

planes = Plane(numPlanes);
 for i = 1:length(planes)
     planes(i,1) = Plane(rawdata(((3*(i - 1))+1):(3*(i - 1))+3,:));
 end
