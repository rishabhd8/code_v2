function [ distances] = analyse_connections_spatially(adjmat,hierarchy)
%Returns a vector of length no. of edges containing the distance across the hierarchy each edge covers. Use hist(distance) to make a histogram out of this.
[i,j,v]=find(adjmat);
distances=zeros(size(i));
for k=1:length(i)
    ancestors_1=get_ancestors(i(k),hierarchy);
    ancestors_2=get_ancestors(j(k),hierarchy);
    distances(k)=length(intersect(ancestors_1,ancestors_2))/length(union(ancestors_1,ancestors_2));
end
end

