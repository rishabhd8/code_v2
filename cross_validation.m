function [ acc,convergence,preds,sent,fold ] = cross_validation(connectivity,hierarchy,labels,no_of_iterations,k,unknownstr,s)
%CROSS VALIDATION FUNCTION
%DOES CV on leaf-only neighbor-only.
%s=no of folds
%first make folds
no_of_nodes=length(labels);
fold=stratified_cv(labels,s);
if(s==no_of_nodes)
    fold=1:s;
end
convergence=zeros(1,s);
correct=zeros(1,s);
wrong=zeros(1,s);
preds=cell(1,length(labels));
sent=cell(size(preds));
for i=1:s
    i
    labels_cur=labels;
    %hide data in that fold
    for j=1:length(fold)
        if(fold(j)==i)
            labels_cur{j}=unknownstr;
        end
    end
    %call the algorithm
    [convergence_data, distribution_data, p_n_indyk, predictions,labels_unique] = indyk_wrapper(hierarchy,connectivity,labels_cur, no_of_iterations,k, unknownstr);
    convergence(i)=convergence_data(end);
    %analyse accuracy
    for j=1:length(fold)
        if(fold(j)==i)
            preds{j}=predictions{j};
            sent{j}=labels_cur{j};
            if(strcmp(predictions{j},labels{j}))
                correct(i)=correct(i)+1;
            else
                wrong(i)=wrong(i)+1;
            end
        end
    end
end
acc=correct./(correct+wrong);
end

