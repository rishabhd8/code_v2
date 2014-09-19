function [convergence_data, distribution_data, p_n_indyk, predictions,labels_unique] = indyk_wrapper_hierarchy(hierarchy,connectivity,labels, no_of_iterations,k, unknownstr)
%This is the wrapper function for Indyk
%hierarchy is adjmat of hierarchy
% connectivity is adjmat of connectivity
%labels is alist of label names. single labels are assumed. Unknown labels
%are assumed to be named- Unknown.

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
connectivity=max(connectivity,connectivity');
convergence_data=zeros(1,no_of_iterations);
distribution_data=cell(1,0);

labelcodes=zeros(1,length(labels));
for i=1:length(labelcodes)
    labelcodes(i)=labels2code(labels{i});
end

no_of_nodes=length(labels);
no_of_labels=length(labels_unique)-1;
unknown_code=no_of_labels+1;

%Estimation of parameters
label_freqs=zeros(1,no_of_labels+1);
interlabel_n=zeros(no_of_labels+1,no_of_labels+1);
interlabel_s=zeros(no_of_labels+1,no_of_labels+1);
interlabel_p=zeros(no_of_labels+1,no_of_labels+1);
for i=1:no_of_nodes
    label_freqs(labelcodes(i))=label_freqs(labelcodes(i))+1;
    for j=1:no_of_nodes
        %isneighbor?
        if(connectivity(i,j)==1)
            interlabel_n(labelcodes(i),labelcodes(j))=interlabel_n(labelcodes(i),labelcodes(j))+1;
            interlabel_n(labelcodes(j),labelcodes(i))=interlabel_n(labelcodes(i),labelcodes(j));
        end
        %isparent?
        if(hierarchy(i,j))
            interlabel_p(labelcodes(i),labelcodes(j))=interlabel_p(labelcodes(i),labelcodes(j))+1;
        end
        %issibling
        if(i~=1 && j~=1 && i~=j && find(hierarchy(:,j),1)==find(hierarchy(:,i),1))
            interlabel_s(labelcodes(i),labelcodes(j))=interlabel_s(labelcodes(i),labelcodes(j))+1;
            interlabel_s(labelcodes(j),labelcodes(i))=interlabel_s(labelcodes(i),labelcodes(j));
        end
    end
end
interlabel_n=interlabel_n/2;
interlabel_s=interlabel_s/2;
p_n_indyk=interlabel_n(1:end-1,1:end-1);
%Add-1 smoothening
for i=1:no_of_labels
    p_n_indyk(i,:)=(interlabel_n(i,1:end-1)+1)/sum(interlabel_n(i,1:end-1)+1);
end
p_s_indyk=interlabel_s(1:end-1,1:end-1);
for i=1:no_of_labels
    p_s_indyk(i,:)=(interlabel_s(i,1:end-1)+1)/sum(interlabel_s(i,1:end-1)+1);
end
p_labels=row_normalization(label_freqs(1:end-1));
p_s=interlabel_s(1:end-1,1:end-1);
p_s=p_s+1;
p_p=interlabel_p(1:end-1,1:end-1);
p_p=p_p+1;
for i=1:no_of_labels
    for j=1:no_of_labels
        if(i==j)
            p_s(i,j)=p_s(i,j)/(nchoosek(label_freqs(i),2)+1);
            p_p(i,j)=p_p(i,j)/(nchoosek(label_freqs(i),2)+1);
        else
            p_s(i,j)=p_s(i,j)/(label_freqs(i)*label_freqs(j)+1);
            p_p(i,j)=p_p(i,j)/(label_freqs(i)*label_freqs(j)+1);
        end
    end
end
%create an initial guess
uniform_distribution=ones(no_of_nodes,no_of_labels)/no_of_labels;
prior_based_distribution=zeros(no_of_nodes,no_of_labels);
for i=1:no_of_nodes
    prior_based_distribution(i,:)=p_labels;
end
random_distribution=row_normalization(rand(no_of_nodes,no_of_labels));
%text_based=text_based_initial_estimation(hierarchy,connectivity,labels);
initial_distribution=prior_based_distribution;

%do iterations
%distribution_next=zeros(no_of_nodes,no_of_labels);
%distribution_cur=zeros(no_of_nodes,no_of_labels);
distribution_cur=initial_distribution;
for i=1:no_of_iterations
    i
    distribution_next=collective_inference_with_hierarchy(distribution_cur,hierarchy,connectivity,labelcodes,labels_unique,k,p_n_indyk,p_s,p_p,p_s_indyk,p_labels);
    convergence_data(i)=sum(sum((distribution_next-distribution_cur).^2));
    distribution_cur=distribution_next;
    distribution_data{1,end+1}=distribution_next;
end

%return predictions
distribution_final=distribution_data{1,end};
[~,predictions_code]=max(distribution_final,[],2);
predictions=cell(1,no_of_nodes);
for i=1:no_of_nodes
    if(~strcmp(labels{i},unknownstr))
        predictions{i}='nil';
    else
        predictions{i}=labels_unique{predictions_code(i)};
    end
end    
end

