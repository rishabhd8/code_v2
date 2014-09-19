function [ result ] = shannon_entropy(x)
%elementwise shannon entropy
[r,c]=size(x);
result=zeros(r,c);
for i=1:r
    for j=1:c
        if(x(i,j)==1 || x(i,j)==0)
            result(i,j)=0;
        else
            result(i,j)=log(x(i,j))*x(i,j)+log(1-x(i,j))*(1-x(i,j));
        end
    end
end
end

