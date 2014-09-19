function [ distribution ] = node_model_3( neighbor_labels,children_labels,sibling_labels,parent_label,parameters_n,parameters_s,label_priors)
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
end
children_counts=hist(children_labels,1:no_of_labels);
children_counts=children_counts+1;
distribution=distribution.*children_counts;
for i=1:no_of_labels
    for j=1:length(sibling_labels);
        distribution(i)=distribution(i)*parameters_s(i,sibling_labels(j));
    end
end
sibling_counts=hist(sibling_labels,1:no_of_labels);
if(~isempty(parent_label))
    update=ones(1,length(distribution))*sibling_counts(parent_label);
    update(parent_label)=update(parent_label)+1;
    distribution=distribution.*update;
end
distribution=distribution/sum(distribution);
end




