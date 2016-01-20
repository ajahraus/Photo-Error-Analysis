function b = readVarianceFromFEBMUNoutput(filename)
fid = fopen(['C://FEMBUN2016//',filename,'.out']);
a = fscanf(fid,'%s');
Index = 0;
newSize = round(length(a)/60);

b = reshape(a(1: newSize*60),60,newSize)';
for i = 1:size(b,1)
    if strcmp('OBJECTPOINTSTANDARDERRORELLIPSOIDS(19.9%CONFIDENCEREGIONS)CO', b(i,:))
        disp(b(i,:))
        disp(b(i+1,:))
        disp(b(i+2,:))
    end
end