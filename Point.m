classdef Point
    properties
        xyz
        pointName
        planeName
    end
    methods
        function obj = Point(varargin)
            if length(varargin) == 2
                obj.xyz = varargin{1};
                obj.pointName = obj.GenerateRandomPointName(10);
                obj.planeName = varargin{2}.name;
            elseif length(varargin) == 1
                obj.xyz = varargin{1};
                obj.pointName = obj.GenerateRandomPointName(10);
                obj.planeName = '';
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
            name = ['P',name];
        end
    end
end