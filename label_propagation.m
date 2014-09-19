function [convergence, predictions] = label_propagation(connectivity,hierarchy,labels,no_of_iterations,unknownstr )
%Performs label propagation using connectivity only.
connectivity=max(connectivity,connectivity');
hierarchy=max(hierarchy,hierarchy');
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%prepare data
labels_unique=unique(labels);
%put the unknown str at the end of labels_unique
i=1;
while(i<=length(labels_unique) && ~strcmp(labels_unique{i},unknownstr))
    i=i+1;
end
labels_unique{i}=labels_unique{end};
labels_unique{end}=unknownstr;

labels2code=containers.Map(labels_unique,1:length(labels_unique));
convergence_data=zeros(1,no_of_iterations);
distribution_data=cell(1,0);

labelcodes=zeros(1,length(labels));
for i=1:length(labelcodes)
    labelcodes(i)=labels2code(labels{i});
end

no_of_nodes=length(labels);
no_of_labels=length(labels_unique)-1;
unknown_code=no_of_labels+1;

%Make initial guess
Y_initial=zeros(no_of_nodes,no_of_labels);
for i=1:no_of_nodes
    if(labelcodes(i)~=unknown_code)
        Y_initial(i,labelcodes(i))=1;
    else
        Y_initial(i,:)=1/no_of_labels;
    end
end

%compute transition matrix
T_connectivity=zeros(no_of_nodes,no_of_nodes);
T_hierarchy=zeros(no_of_nodes,no_of_nodes);
for i=1:no_of_nodes
    T_hierarchy(i,:)=hierarchy(i,:)/sum(hierarchy(i,:));
    c_degree=sum(connectivity(i,:));
    if(c_degree==0)
        T_connectivity(i,:)=zeros(1,no_of_nodes);
    else
        T_connectivity(i,:)=connectivity(i,:)/sum(connectivity(i,:));
    end
end

%do iterations
Y_now=Y_initial;
convergence=zeros(1,no_of_iterations);
for i=1:no_of_iterations
    i
    if(rem(i,2)==0)
        T=T_connectivity;
    else
        T=T_connectivity;
    end
    Y_next=T*Y_now;
    %clamp and row normalize
    for j=1:no_of_nodes
        if(labelcodes(j)~=unknown_code)
            Y_next(j,:)=0;
            Y_next(j,labelcodes(j))=1;
        else
            sumY=sum(Y_next(j,:));
            if(sumY~=0)
                Y_next(j,:)=Y_next(j,:)/sumY;
            else
                Y_next(j,:)=ones(1,no_of_labels)/no_of_labels;
            end
        end
    end
    convergence(i)=sum(sum((Y_next-Y_now).^2));
    Y_now=Y_next;
end

%make predictions
%return predictions
distribution_final=Y_next;
[dummy,predictions_code]=max(distribution_final,[],2);
predictions=cell(1,no_of_nodes);
for i=1:no_of_nodes
    if(~strcmp(labels{i},unknownstr))
        predictions{i}='nil';
    else
        predictions{i}=labels_unique{predictions_code(i)};
    end
end    
end

