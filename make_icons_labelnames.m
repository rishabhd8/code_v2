function [] = make_icons_labelnames( labels,colormap,unique_labels,dir )
emptystr={''};
label2code=containers.Map(unique_labels,1:length(unique_labels));
for i=1:length(labels)
    label=label2code(labels{i});
    figure;
    h=pie(ones(size(label)),repmat(emptystr,size(label)));
    color_handles=h(1:2:end);
    for j=1:length(label)
        label
        j
        set(color_handles(j),'FaceColor',colormap(label,:));
    end
    print('-djpeg','-r7',[pwd strcat(dir,num2str(i),'.jpg')]);
    close();
end
end

