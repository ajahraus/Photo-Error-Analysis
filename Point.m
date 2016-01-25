classdef Point < handle
    properties
        xyz
        pointName
        planeName
        numObs
        imgNames
        variance
    end
    methods
        function obj = Point(varargin)
            if length(varargin) == 2
                obj.xyz = varargin{1};
                obj.pointName = obj.GenerateRandomPointName(10);
                obj.planeName = varargin{2}.name;
                obj.numObs = 0;
                obj.imgNames = [];
                obj.variance = 0;
            elseif length(varargin) == 1
                obj.xyz = varargin{1};
                obj.pointName = obj.GenerateRandomPointName(10);
                obj.planeName = '';
                obj.numObs = 0;
                obj.imgNames = [];
                obj.variance = 0;
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