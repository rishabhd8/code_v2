function [ output_args ] = create_color_plate_v2(colormap,unique_labels,dir)
%Creates a colorkey for the visualization.
%Color map: A matrix with (no-of-labels)x3 size. Represents RGB value for
%each label.
%unique_labels: the unique label names in the order as colormap.
%dir: address of the directory where to save the colormap.
for i=1:length(unique_labels)
    subplot(5,4,i);
    h=pie(1,{''});
    title(unique_labels{i});
    color_handles=h(1:2:end);
    set(color_handles(1),'FaceColor',colormap(i,:));
    for j=1:length(h)
        %set(h(j),'EdgeColor','none');
        %set(gca,'color','none');
        %set(gcf,'color','none');
    end
end
print('-djpeg',[pwd strcat(dir,'colorplate.jpg')]);
end

