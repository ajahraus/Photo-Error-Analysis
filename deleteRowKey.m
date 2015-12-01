function out = deleteRowKey(in, key)
% Deletes rows in the input, according to the zeros in a vector of the same
% length. Values of 1 are kept, values of 0 are deleted
total = sum(key);
out = zeros(total, size(in,2));

j = 1;

for i = 1:size(in,1)
    if key(i)
        out(j,:) = in(i,:);
        j = j+1;
    end
end