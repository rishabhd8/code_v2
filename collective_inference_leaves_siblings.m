function [ distribution_updated ] = collective_inference_leaves_siblings(distribution, siblings_mat, connectivity, labels_code, labels_names,k, parameters_n,parameters_s, label_priors)
%COLLECTIVE INFERENCE USING NEIGHBOR+SIBLING ON LEAVES ONLY.
%this function performs one iteration of collective inferencing
%distribution: the estimated distribution over labels from the previous
%iteration.
%sibling_mat:A matrix S such that S(i,j)=1 iff i-j are siblings.
%connectivity: the adjmat for the connectivity matrix.
%labels_code: the coded labels.
%label_names: the unique label names in the order of their codes.
%k: With how many terms to truncate the summation. BY DEFAULT: Pass as no
%of labels.
%parameters_n: P(l_i|l_j,i-j are neighbors).
%parameters_s: P(l_i|l_j, i-j are siblings).
%label_priors: the frequency of various labels 
%distribution_updated: the updated distribution.
%symetricize connectivity
%USE WITH SIBLING+LEAVES ONLY
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
	siblings=(siblings_mat(i,:)==1);
	all=neighbors|siblings;
    unknown_neighbors=neighbors & (labels_code==unknown);
	unknown_siblings=siblings & (labels_code==unknown);
	unknown_all=unknown_siblings|unknown_neighbors;
	sibling_pos=siblings(all);
	neighbor_pos=neighbors(all);
    if(~isempty(labels_code(unknown_all)))
    [kmostlikely,likelihoods]=k_best_assignments_n_2(distribution(unknown_all,:),k);
    for j=1:k
        likelihood=likelihoods(j);
        assignment=labels_code(all);
        %assignment
        %kmostlikely{j}
        assignment(assignment==unknown)=kmostlikely{j};
        %assignment
        distribution_updated(i,:)=distribution_updated(i,:)+likelihood*node_model_leaves_sibling(assignment(neighbor_pos),assignment(sibling_pos),parameters_n,parameters_s,label_priors);
    end
    else
        assignment=labels_code(all);
        distribution_updated(i,:)=node_model_leaves_sibling(assignment(neighbor_pos),assignment(sibling_pos),parameters_n,parameters_s,label_priors);
    end
    distribution_updated(i,:)=distribution_updated(i,:)/sum(distribution_updated(i,:));
    end
end
end

