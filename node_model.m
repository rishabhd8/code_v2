function [ distribution ] = node_model( neighbor_labels,parameters_n,label_priors)
%the function computes a probability distribution over labels for a node
%given the labels of its neighbors parameters is the
%no_of_labelsxno_of_labels matrix label_priors are the prior distribution
%of labels
[no_of_labels,x]=size(parameters_n);
distribution=ones(1,no_of_labels);
for i=1:no_of_labels
    for j=1:length(neighbor_labels);
        distribution(i)=distribution(i)*parameters_n(i,neighbor_labels(j));
    end
    distribution(i)=distribution(i)*label_priors(i);
end
distribution=distribution/sum(distribution);
end




