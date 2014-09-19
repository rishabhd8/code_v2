function [ distribution ] = node_model_sibling_parent( neighbor_labels,children_labels,siblings_labels,parent_label,parameters_n,parameters_s,label_priors)
%the function computes a probability distribution over labels for a node
%given the labels of its neighbors parameters is the
%no_of_labelsxno_of_labels matrix label_priors are the prior distribution
%of labels
[no_of_labels,x]=size(parameters_n);
distribution=ones(1,no_of_labels);
for i=1:no_of_labels
    for j=1:length(neighbor_labels)
        distribution(i)=distribution(i)*parameters_n(i,neighbor_labels(j));
    end
    distribution(i)=distribution(i);
end
%compute the children compatibilities pairwise
%compute the count of all labels in the children
children_counts=hist(children_labels,1:no_of_labels);
children_counts=children_counts+1;
distribution=distribution.*children_counts;
%compute the compatibility of the label with each of the siblings
for i=1:no_of_labels
    for j=1:length(siblings_labels)
        distribution(i)=parameters_s(i,siblings_labels(j));
    end
end
%now compute compatibility with of parent with siblings and label
if(~isempty(parent_label))
siblings_count=hist(siblings_labels,1:no_of_labels);
siblings_count=siblings_count+1;
siblings_count=siblings_count(parent_label);
update=ones(1,no_of_labels)*siblings_count;
update(parent_label)=update(parent_label)+1;
distribution=distribution.*update;
end
distribution=distribution/sum(distribution);
end



