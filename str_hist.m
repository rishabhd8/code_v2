function [ counts,uniquestr ] = str_hist(strarray,uniquestr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%uniquestr=unique(strarray);
counts=zeros(1,length(uniquestr));
str2code=containers.Map(uniquestr,1:length(uniquestr));
for i=1:length(strarray)
    counts(str2code(strarray{i}))=counts(str2code(strarray{i}))+1;
end
bar(1:length(uniquestr),counts);
xticklabel_rotate(1:length(uniquestr),90,uniquestr)

end

