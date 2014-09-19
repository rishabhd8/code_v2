function [ node_roles, connectivity, labels ] = block_model( no_of_nodes, no_of_classes, interclass_matrix, class_prior, erasure_probability)
%This function creates a random graph out of given block model
%This is general directed block model, this means that the inter_class
%matrix can be assymetric and the generated graph will also be assymmetric
%However, u can make symmetric block model graphs by passing in symmetric
%interclass matrix and symmetricizing the outputed connectivity matrix by
%max(connectivity,connectivity')
%no_of_nodes: No of nodes in the graph.
%no_of_classes: No of blocks
%interclass_matrix: Class wise edge probabilities.
%class_prior: The relative frequencies of each class
%Erasure probability: Use for modelling missing labels, the probability that
%a label once generated will be erased and not observed. Pass as 0 if u dont want to do
%this.
%Return values:
%node_roles: The real unerased roles of each vertex.
%connectivity: The generated adjacency matrix (FULL, make sparse() if
%required
%labels: the observed classes: labels which are erased are displayed as
%unknown.
%The function also creates Netkit files for the network. Simply delete them
%if not required.
node_roles=rand(1,no_of_nodes);
cdf=cumsum(class_prior);
cdf=[0,cdf];
for i=1:no_of_nodes
    j=1;
    while(cdf(j)<=node_roles(i))
        j=j+1;
    end
    node_roles(i)=j-1;
end

%Now generate a graph according to the model
connectivity=zeros(no_of_nodes,no_of_nodes);
for i=1:no_of_nodes
    i
    for j=i+1:no_of_nodes
        edge=rand();
        if(edge<interclass_matrix(node_roles(i),node_roles(j)))
            connectivity(i,j)=1;
        end
    end
end

%Now decide what labels to erase
erased=(rand(1,no_of_nodes)<erasure_probability);

%Now make all the files required for netkit
if(false)
fwrite=fopen('random-schema.arff','w');
fprintf(fwrite,'@nodetype Random-Region\n@attribute Code KEY\n@attribute Function {');
for i=1:no_of_classes-1
    i
    fprintf(fwrite,strcat(num2str(i),', '));
end
fprintf(fwrite,strcat(num2str(no_of_classes),'}\n@nodedata random-truth.csv\n\n@edgetype Linked Random-Region Random-Region\n@Reversible\n@edgedata random-link.rn'));
fclose(fwrite);


%now create edge file
fwrite=fopen('random-link.rn','w');
[to,from,~]=find(connectivity);
for i=1:length(to)
    i/length(to)
    fprintf(fwrite,strcat(num2str(from(i)),',',num2str(to(i)),',1\n'));
end
fclose(fwrite);

%now create trutht file
fwrite=fopen('random-truth.csv','w');
for i=1:no_of_nodes
    i
    fprintf(fwrite,strcat(num2str(i),',',num2str(node_roles(i)),'\n'));
end
fclose(fwrite);

%now create a known file
fwrite=fopen('random-known.csv','w');
for i=1:no_of_nodes
    i
    if(~erased(i))
        fprintf(fwrite,strcat(num2str(i),',',num2str(node_roles(i)),'\n'));
    end
end
fclose(fwrite);
end
%now prepare data for your code
labels_mat=node_roles;
labels_mat(erased)=no_of_classes+1;
labels=cell(1,length(labels_mat));
for i=1:length(labels)
    labels{i}=num2str(labels_mat(i));
end
end

