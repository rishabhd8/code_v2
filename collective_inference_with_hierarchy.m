function [ distribution_updated ] = collective_inference_with_hierarchy(distribution, hierarchy, connectivity, labels_code, labels_names,k, parameters_n,parameters_s,parameters_p,p_s_indyk,label_priors)
%PERFORMS COLLECTIVE INFERENCE OVERALL NODES USING HIERARCHY+ADJMAT
%DOESNT CONVERGE WELL
%SIMULATED ANNEALING TO BE IMPLEMENTED SOON.
%%distribution: the estimated distribution over labels from the previous
%iteration.
%hierarchy: the adjmat for the hierarchy. Note the function DOESNT use it.
%connectivity: the adjmat for the connectivity matrix.
%labels_code: the coded labels.
%label_names: the unique label names in the order of their codes.
%k: With how many terms to truncate the summation. BY DEFAULT: Pass as no
%of labels.
%parameters_n: P(i is neighbor j|l_j l_i): CHECK ONCE
%parameters_s: P( i is sibling j| l_i, l_j) 
%p_s_indyk: P(l_i|l_j, i-j are siblings)
%parameters_p: P(i is parent j|l_j l_i): CHECK ONCE
%label_priors: the frequency of various labels 
%distribution_updated: the updated distribution.
%symetricize connectivity

connectivity=max(connectivity,connectivity');
%performs one iteration of relaxation labelling on distribution
unknown=length(labels_names);
[no_of_nodes,no_of_labels]=size(distribution);
distribution_updated=zeros(size(distribution));
for i=1:no_of_nodes
    if(labels_code(i)==unknown)
    %i
    %find its unknown labels
    neighbors=(connectivity(i,:)==1);
    no_of_neighbors=sum(neighbors(:));
    %find parent
    parent=(hierarchy(:,i)==1)';
    parent_ind=find(hierarchy(:,i),1);
    %no_of_parents=length(parent);
    %find siblings
    if(~isempty(parent_ind))
        siblings=(hierarchy(parent_ind,:)==1);
    else
        siblings=(hierarchy(1,:)==2);
    end
    %no_of_siblings=length(siblings);
    %find children
    children=(hierarchy(i,:)==1);
    %no_of_children=length(children);
    %merge them all as neigbhors
    all=neighbors | parent | siblings | children;
    unknown_all=all & (labels_code==unknown);
    n_ids=neighbors(all);
    s_ids=siblings(all);
    c_ids=children(all);
    p_ids=parent(all);
    if(~isempty(labels_code(unknown_all)))
    [kmostlikely,likelihoods]=k_best_assignments_n_2(distribution(unknown_all,:),k);
    for j=1:k
        likelihood=likelihoods(j);
        assignment=labels_code(all);
        %assignment
        %kmostlikely{j}
        assignment(assignment==unknown)=kmostlikely{j};
        %assignment
        assignment_n=assignment(n_ids);
        assignment_c=assignment(c_ids);
        assignment_s=assignment(s_ids);
        assignment_p=assignment(p_ids);
        %distribution_updated(i,:)=distribution_updated(i,:)+likelihood*node_model_sibling_parent(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,parameters_s,label_priors);
        %distribution_updated(i,:)=distribution_updated(i,:)+likelihood*node_model_2(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,parameters_p,label_priors);
        distribution_updated(i,:)=distribution_updated(i,:)+likelihood*node_model_3(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,p_s_indyk,label_priors);
    end
    else
        assignment=labels_code(all);
        assignment_n=assignment(n_ids);
        assignment_c=assignment(c_ids);
        assignment_s=assignment(s_ids);
        assignment_p=assignment(p_ids);
        %distribution_updated(i,:)=node_model_sibling_parent(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,parameters_s,label_priors);
        %distribution_updated(i,:)=node_model_2(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,parameters_p,label_priors);
        distribution_updated(i,:)=distribution_updated(i,:)+likelihood*node_model_3(assignment_n,assignment_c,assignment_s,assignment_p,parameters_n,p_s_indyk,label_priors);
    end
    distribution_updated(i,:)=distribution_updated(i,:)/sum(distribution_updated(i,:));
    end
end
end

