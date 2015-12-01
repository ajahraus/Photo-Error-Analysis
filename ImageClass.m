classdef ImageClass
   properties
       location
       direction
       imageData
       camera
   end
   
   methods
       function obj = Image(loc, dir, cam)
           obj.location = loc;
           obj.direction = dir;
           obj.camera = cam;
       end
   end
end