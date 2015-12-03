classdef ImageClass
   properties
       location
       direction
       imageData
       camera
       ImageID
   end
   
   methods
       function obj = ImageClass(loc, dir, cam)
           obj.location = loc;
           obj.direction = dir;
           obj.camera = cam;
           
           % Something should be done here to ensure uniqueness 
           obj.ImageID = obj.GenerateRandomImageName(10);
           
           % This also needs to relate to the planar models. Probably
           % appropriate to create its own function, though. 
           obj.imageData = [];
       end
   end
   
   methods (Static)
       function name = GenerateRandomImageName(lengthOfName)
           
           setOfValidChars = char(['a':'z','0':'9']);
           num = length(setOfValidChars );
           randIndexs =  ceil( num*rand(1,lengthOfName) );
           name = char(zeros(size(1,lengthOfName)));
           
           for i = 1:lengthOfName
               name(i) = setOfValidChars(randIndexs(i));
           end
       end
   end
end