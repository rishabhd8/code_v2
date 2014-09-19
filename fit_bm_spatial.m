function [ smpl,accept,likelihood ] = fit_bm_spatial(adjmat,no_smpls, n_part,hierarchy,user_start,usestart)
%SPATIAL BLOCK MODEL, IN PROGRESS. 
%symmetrical adjmat
adjmat=max(adjmat,adjmat');
[n,~]=size(adjmat);
[n_total,~]=size(hierarchy);
%fits a block model

%make a map to get leaf index from total index
leaf_ind=find(sum(hierarchy,2)==0);
%find the heights of all leaves for later use
heights=findheights(hierarchy);
[~,heights_order]=sort(-heights);
%make parent array for use:
parent=zeros(1,n_total);
for i=1:n_total
    t=find(hierarchy(:,i));
    if(isempty(t))
        parent(i)=-1;
    else
        parent(i)=t;
    end
end

%compute the leaves
leafmat=zeros(size(adjmat));
for i=1:n
    leafmat(i,getleaves(i,hierarchy))=1;
end

%define function handles

tarpdf_handle = @(x) tarpdf(x,adjmat,n_part,hierarchy,parent,heights_order,leaf_ind);
proppdf_handle= @(x,y) proppdf(x,y,n_part);
proprnd_handle=@(x) proprnd(x,n_part);
start=zeros(1,n);
if(usestart==1)
    start=user_start;
else
    for i=1:n
        start(i)=unidrnd(n_part);
    end
end

tarpdf_handle(start)
%proprnd_handle(start);
%proppdf_handle(start,proprnd_handle(start))
[smpl,accept] = mhsample_my(start,no_smpls,'logpdf',tarpdf_handle,'logproppdf',proppdf_handle, 'proprnd',proprnd_handle,'symmetric',true);
likelihood=zeros(1,no_smpls);
for i=1:no_smpls
    likelihood(i)=tarpdf_handle(smpl(i,:));
end
end

function [proposal]=proprnd(partition,n_part)
%select a random node
select=unidrnd(length(partition));
from=partition(select);
moveto=unidrnd(n_part-1);
if(moveto==from)
    moveto=n_part;
end
proposal=partition;
proposal(select)=moveto;
end

function [logprob]=proppdf(partition1,partition2,n_part)
if(sum(partition1~=partition2)==1)
    logprob=-log(n_part-1);
else
    logprob=-inf;
end
end


function [logprob]=tarpdf(partition,adjmat,n_part,hierarchy,parent,heights_order,leaf_ind)
%do mle for for params
params=zeros(n_part,n_part);
edgecounts=zeros(size(params));
nonedgecounts=zeros(size(params));
n=length(partition);
freqs=zeros(1,n_part);
for i=1:n
    freqs(partition(i))=freqs(partition(i))+1;
    for j=i+1:n
        if(adjmat(i,j))
            edgecounts(partition(i),partition(j))=edgecounts(partition(i),partition(j))+1;
            edgecounts(partition(j),partition(i))=edgecounts(partition(i),partition(j));
        else
            nonedgecounts(partition(i),partition(j))=nonedgecounts(partition(i),partition(j))+1;
            nonedgecounts(partition(j),partition(i))=nonedgecounts(partition(i),partition(j));
        end
    end
end
for i=1:n_part
    if(freqs(i)>=2)
        params(i,i)=(edgecounts(i,i))/(nchoosek(freqs(i),2));
    else
        params(i,i)=0.5;
    end
    for j=i+1:n_part
        if(freqs(i)>0 && freqs(j)>0)
            params(i,j)=(edgecounts(i,j))/(freqs(i)*freqs(j));
        else
            params(i,j)=0.5;
        end
        params(j,i)=params(i,j);
    end
end
%do mle for hierarchy parameters

logprob=sum(sum(triu((edgecounts+nonedgecounts).*shannon_entropy(params))));
logprob=logprob+log(mle_hierarchy(partition,hierarchy,heights_order,parent,leaf_ind,n_part));
end


%mle hierarchy
function [likelihood]=mle_hierarchy(partition,hierarchy,heights_order,parent,leaf_ind,k)
[n,~]=size(hierarchy);
composition=zeros(n,k);
%assign the values to leaves first
for i=1:length(leaf_ind)
    composition(leaf_ind(i),partition(i))=1;
end
%now assign composition to leaves higher up
for i=heights_order
    if(sum(composition(i,:))==0)
        composition(i,:)=sum(composition(hierarchy(i,:)==1,:),1);
    end
end
composition
%now compute likelihood for the hierarchy term
likelihood=1;
for i=1:length(leaf_ind)
    t_id=leaf_ind(i);
    p=partition(i);
    leaflike=1;
    cur=t_id;
    par=parent(t_id);
    while(par~=-1)
        leaflike=leaflike*composition(cur,p)/composition(par,p);
        cur=par;
        par=parent(cur);
    end
    likelihood=likelihood*leaflike;    
end
end
