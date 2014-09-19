
function [logprob]=tarpdf(partition,adjmat,n_part)
%do mle for for params
params=zeros(n_part,n_part);
edgecounts=zeros(size(params));
nonedgecounts=zeros(size(params));
n=length(partition);
freqs=zeros(1,length(partition));
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
for i=1:n
    if(freqs(i)>=2)
        params(i,i)=(edgecounts(i,i))/(nchoosek(freqs(i),2));
    else
        params(i,i)=0.5;
    end
    for j=i+1:n
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
