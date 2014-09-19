function [ startpts,endpts ] = visualize_sparsity(connectivity,labels,isleaf)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
unique_labels=unique(labels);
n=length(labels);
%make sure that the leaves occur before the non leaves
[~,order1]=sort(isleaf);
connectivity=connectivity(order1,order1);
labels=labels(order1);
isleaf=isleaf(order1);
[~,order2]=sort(labels);
labels=labels(order2);
isleaf=isleaf(order2);
connectivity=connectivity(order2,order2);
%now find the endpoints of labels
startpts=zeros(1,length(unique_labels));
endpts=zeros(1,length(unique_labels));
startpts(1)=1;
beg=1;
i=1;
cur=1;
for i=1:n-1
    if(~strcmp(labels(i),labels(i+1)))
            endpts(cur)=i;
            cur=cur+1;
            startpts(cur)=i+1;
    end
end
endpts(end)=n;
midpts=(startpts+endpts)*0.5;
%insert dividing rows
%marked_adjmat=zeros(0,n);
%for i=1:length(endpts)
    %marked_adjmat=[marked_adjmat;connectivity(startpts(i):endpts(i),:)];
    %marked_adjmat=[marked_adjmat;ones(5,n)];
%end
%for i=1:length(endpts)
    %marked_adjmat=[marked_adjmat(:,1:endpts(i)),ones(5*length(unique_labels)+n,5),marked_adjmat(:,endpts(i)+1:end)];
    %endpts(i)=endpts(i)+(i-1)*5;
    %startpts(i)=startpts(i)+(i-1)*5;
%end
%midpts=0.5*(endpts+startpts);
grid on
spy(connectivity);
grid on
set(gca, 'GridLineStyle', '-')
set(gca,'YTick',endpts(1:end),'fontsize',7);
set(gca,'XTick',endpts(1:end),'fontsize',7);
set(gca,'YTickLabel',unique_labels)
xticklabel_rotate(endpts,90,unique_labels);  
end

