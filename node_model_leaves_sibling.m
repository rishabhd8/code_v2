function [ distribution ] = node_model_leaves_sibling(neighbor_labels, sibling_labels,parameters_n,parameters_s,label_priors)
%the function computes a probability distribution over labels for a node
%given the labels of its neighbors and sibling parameters is the
% USED WITH LEAVES+SIBLING INFO
%no_of_labelsxno_of_labels matrix label_priors are the prior distribution
%of labels
[no_of_labels,x]=size(parameters_n);
distribution=ones(1,no_of_labels);
for i=1:no_of_labels
    for j=1:length(neighbor_labels);
        distribution(i)=distribution(i)*parameters_n(i,neighbor_labels(j));
    end
	for j=1:length(sibling_labels);
        distribution(i)=distribution(i)*parameters_s(i,sibling_labels(j));
    end	
    distribution(i)=distribution(i)*label_priors(i);
end
distribution=distribution/sum(distribution);
end




