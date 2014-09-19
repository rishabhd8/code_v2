function [] = make_icons( label_codes,colormap )
%Makes icons for given label codes and colormap.
%multiple labels are supported.
%dash labels are not supported.
emptystr={''};
for i=1:length(label_codes)
    figure;
    labels=label_codes{i};
    h=pie(ones(size(labels)),repmat(emptystr,size(labels)));
    color_handles=h(1:2:end);
    for j=1:length(labels)
        set(color_handles(j),'FaceColor',colormap(labels(j),:));
    end
    for j=1:length(h)
        %set(h(j),'EdgeColor','none');
        %set(gca,'color','none');
        %set(gcf,'color','none');
    end
    print('-djpeg','-r7',[pwd strcat('/icons_lprop/',num2str(i),'.jpg')]);
    close();
end
end

