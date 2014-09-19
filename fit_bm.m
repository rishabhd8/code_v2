function [ smpl,accept,likelihood ] = fit_bm(adjmat,no_smpls, n_part,user_start,usestart)
%FITS A BLOCK MODEL to the adjacency matrix.
%adjmat: connectivity matrix.
%no_of_smpls: number of samples to generate.
%n_part: maximum no of allowed class.
%user_start: user specified start value
%usestart: 1 if u want to use ur start, 0 otherwise.
%symmetrical adjmat
adjmat=max(adjmat,adjmat');
[n,~]=size(adjmat);
%fits a block model
%define function handles

tarpdf_handle = @(x) tarpdf(x,adjmat,n_part);
proppdf_handle= @(x,y) proppdf(x,y,n_part);
proprnd_handle=@(x) proprnd(x,n_part);
start=zeros(1,n);
if(usestart)
    start=user_start;
else
    for i=1:n
        start(i)=unidrnd(n_part);
    end
end

%tarpdf_handle(start)
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


function [logprob]=tarpdf(partition,adjmat,n_part)
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
logprob=sum(sum(triu((edgecounts+nonedgecounts).*shannon_entropy(params))));
end

