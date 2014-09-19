function [ interlabel_n,interlabel_s,interlabel_p ] = estimate_parameters( connectivity,hierarchy,labels, unknownstr )
%Parameter Estimation of parent,sibling and neigbhor matrices.
%DO VERSION CONTROL OF THIS FUNCTION ITS A REPEAT.
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
%convergence_data=zeros(1,no_of_iterations);
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
        if(i~=1 && j~=1 && find(hierarchy(:,j),1)==find(hierarchy(:,i),1) && i~=j)
            interlabel_s(labelcodes(i),labelcodes(j))=interlabel_s(labelcodes(i),labelcodes(j))+1;
            interlabel_s(labelcodes(j),labelcodes(i))=interlabel_s(labelcodes(i),labelcodes(j));
        end
    end
end
interlabel_n=interlabel_n/2;
interlabel_s=interlabel_s/2;

end

