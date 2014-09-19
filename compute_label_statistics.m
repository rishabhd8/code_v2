function [ ctr,label_freqs_leaves,label_freqs_internal, interlabel_neighbours, interlabel_parents, interlabel_siblings, coccurence ] = compute_label_statistics(labels_code, hierarchy, connectivity_matrix,unique_labels)
%Used for computing the parent, child and sibling matrices for data
%analysis.


%function [ label_freqs_leaves,label_freqs_internal, interlabel_neighbours, interlabel_parents, interlabel_siblings ] = compute_label_statistics(labels_code, hierarchy, connectivity_matrix)
%connectivity_matrix=max(connectivity_matrix,connectivity_matrix');
degree_hierarchy=sum(hierarchy');
degree_connectivity=sum(max(connectivity_matrix,connectivity_matrix'));
label_freqs_leaves=zeros(1,length(unique_labels));
label_freqs_internal=zeros(1,length(unique_labels));
interlabel_neighbours=zeros(length(unique_labels),length(unique_labels));
coccurence=zeros(length(unique_labels),length(unique_labels));
interlabel_parents=zeros(length(unique_labels),length(unique_labels));
interlabel_siblings=zeros(length(unique_labels),length(unique_labels));
ctr=0;
for i=1:length(labels_code)
    code=labels_code{i};
    for j=1:length(code)
        for k=j+1:length(code)
            coccurence(code(j),code(k))=coccurence(code(j),code(k))+1;
            coccurence(code(k),code(j))=coccurence(code(j),code(k));
        end
    end
    if(degree_hierarchy(i)==0)
        ctr=ctr+1
        for j=code
            label_freqs_leaves(j)=label_freqs_leaves(j)+1;
        end
    else
        for j=code
            label_freqs_internal(j)=label_freqs_internal(j)+1;
        end
    end
    neighbours=find(connectivity_matrix(i,:));
    parent=find(hierarchy(:,i));
    siblings=find(hierarchy(i,:));
    if(~isempty(neighbours))
    for j=neighbours
        n_code=labels_code{j};
        for k=n_code
            for l=code
                interlabel_neighbours(l,k)=interlabel_neighbours(l,k)+1;
                %interlabel_neighbours(k,l)=interlabel_neighbours(l,k);
            end
        end
    end
    end
    interlabel_neighbours
    interlabel_parents
    if(~isempty(parent))
        for j=parent
            p_code=labels_code{j};
            for k=p_code
                for l=code
                    j
                    k
                    l
                    interlabel_parents(k,l)=interlabel_parents(k,l)+1; 
                end
            end
        end
    end
    if(~(isempty(siblings)))
    for j=1:length(siblings)
        for k=j+1:length(siblings)
            s1_code=labels_code{siblings(j)};
            s2_code=labels_code{siblings(k)};
            for l=s1_code
                for m=s2_code
                    l
                    m
                    interlabel_siblings(l,m)=interlabel_siblings(l,m)+1;
                    interlabel_siblings(m,l)=interlabel_siblings(l,m);
                end
            end
        end
    end
    end
end
 %interlabel_siblings=interlabel_siblings./2;
 %interlabel_neighbours=interlabel_neighbours./2;
end
    

