function [norm_matrix] = row_normalization(matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
norm_matrix=matrix;
[r,c]=size(norm_matrix);
for i=1:r
    norm_matrix(i,:)=norm_matrix(i,:)/sum(norm_matrix(i,:));
end
end

