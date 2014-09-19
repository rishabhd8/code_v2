function [ fold] = stratified_cv( labels,s )
%creates an s-fold with same proportion of labels as original data
no_of_nodes=length(labels);
%create a random permutation of the data
per=randperm(no_of_nodes);
fold=zeros(1,no_of_nodes);
unique_labels=unique(labels);
label2code=containers.Map(unique_labels,1:length(unique_labels));
ctrs=zeros(1,length(label2code));
for i=1:no_of_nodes
    picked_node=per(i);
    label=labels{picked_node};
    labelcode=label2code(label);
    fold(picked_node)=ctrs(labelcode);
    ctrs(labelcode)=rem((ctrs(labelcode)+1),s);
end
fold=fold+1;
end
