function [ strcell ] = mat2strcell(matrix)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
strcell=cell(1,length(matrix));
for i=1:length(matrix)
    strcell{i}=num2str(matrix(i));
end
end

