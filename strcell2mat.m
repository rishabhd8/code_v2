function [ out] = strcell2mat(cellarr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
out=zeros(1,length(cellarr));
for i=1:length(cellarr)
    out(i)=str2num(cellarr{i});
end
end

