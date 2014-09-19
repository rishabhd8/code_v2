function [ p ] = normalize_frequencies( inter_freqs, label_freqs )
p=zeros(size(inter_freqs));
for i=1:length(label_freqs)
    for j=1:length(label_freqs)
        p(i,j)=inter_freqs(i,j)/(label_freqs(i)*label_freqs(j));
    end
end
end

