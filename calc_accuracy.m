function [ acc, unique_labels ] = calc_accuracy(true_labels, predicted_labels, knownstr)
%This is a general utility function that calculates label-wise prediction
%accuracies given a set of predictions and true labels
%true_labels: its is the set of the true label assignments for each node.
%predicted_labels: this is the set of predictions. Note that labels which
%are already known should have label given by the string knownstr.
%acc: a vector of label wise accuraces. The last entry is the total
%accuracy.
%unique_labels: the order of labels in acc vector.
unique_labels=unique(true_labels);
label2code=containers.Map(unique_labels,1:length(unique_labels));
correct=zeros(1,length(unique_labels));
wrong=zeros(1,length(unique_labels));
for i=1:length(true_labels)
    if(~strcmp(predicted_labels{i},knownstr))
        if(strcmp(true_labels{i},predicted_labels{i}))
            correct(label2code(true_labels{i}))=correct(label2code(true_labels{i}))+1;
        else
            wrong(label2code(true_labels{i}))=wrong(label2code(true_labels{i}))+1;
        end
    end
end
correct=[correct,sum(correct)];
wrong=[wrong,sum(wrong)];
acc=correct./(correct+wrong);

end

