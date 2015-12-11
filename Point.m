classdef Point
    properties
        xyz
        name
    end
    methods
        function obj = Point(xyz)
            if nargin > 0
                obj.xyz = xyz;
                obj.name = obj.GenerateRandomPointName(10);
            end
        end
        
    end
    methods (Static)
        function name = GenerateRandomPointName(lengthOfName)
            
            setOfValidChars = char(['a':'z','0':'9']);
            num = length(setOfValidChars );
            randIndexs =  ceil( num*rand(1,lengthOfName) );
            name = char(zeros(size(1,lengthOfName)));
            
            for i = 1:lengthOfName
                name(i) = setOfValidChars(randIndexs(i));
            end
            name = ['Point_',name];
        end
    end
end