function [] = mat2netkit( connectivity,labels_truth,labels_erased ,filename,unknownstr)
%Now make all the files required for netkit
unique_labels=unique(labels_erased);
%put the unknown str at the end of labels_unique
i=1;
while(i<=length(unique_labels) && ~strcmp(unique_labels{i},unknownstr))
    i=i+1;
end
unique_labels{i}=unique_labels{end};
unique_labels{end}=unknownstr;

no_of_classes=length(unique_labels)-1;
no_of_nodes=length(labels_truth);
fwrite=fopen(strcat(filename,'-schema.arff'),'w');
fprintf(fwrite,'@nodetype Node\n@attribute Code KEY\n@attribute Label {');
for i=1:no_of_classes-1
    fprintf(fwrite,strcat(unique_labels{i},', '));
end
fprintf(fwrite,strcat(unique_labels{no_of_classes},'}\n@nodedata',filename,'-truth.csv\n\n@edgetype Linked Node Node\n@Reversible\n@edgedata',filename,'-link.rn'));
fclose(fwrite);

%now create edge file
fwrite=fopen(strcat(filename,'-link.rn'),'w');
[to,from,~]=find(connectivity);
for i=1:length(to)
    fprintf(fwrite,strcat(num2str(from(i)),',',num2str(to(i)),',1\n'));
end
fclose(fwrite);

%now create truth file
fwrite=fopen(strcat(filename,'-truth.csv'),'w');
for i=1:no_of_nodes
    fprintf(fwrite,strcat(num2str(i),',',labels_truth{i},'\n'));
end
fclose(fwrite);

%now create a known file
fwrite=fopen(strcat(filename,'-known.csv'),'w');
for i=1:no_of_nodes
    if(~strcmp(unique_labels{end},labels_erased{i}))
        fprintf(fwrite,strcat(num2str(i),',',labels_erased{i},'\n'));
    end
end
fclose(fwrite);

end

