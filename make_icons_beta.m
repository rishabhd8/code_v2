function [] = make_icons_beta(label_codes,colormap )
emptystr={''};
x=0.7*sin(0:pi/100:2*pi);
y=0.7*cos(0:pi/100:2*pi);
for i=1:length(label_codes)
    figure;
    labels=label_codes{i};
    if(length(labels)>1)
    h=pie(ones(1,length(labels)-1),repmat(emptystr,[1,length(labels)-1]));
    color_handles=h(1:2:end);
    for j=2:length(labels)
        set(color_handles(j-1),'FaceColor',colormap(labels(j),:));
    end
    for j=1:length(h)
        set(h(j),'EdgeColor','none');
        %set(gca,'color','none');
        %set(gcf,'color','none');
    end
    hold on;
    fill(x,y,colormap(labels(1),:));
    else
        h=pie([1],{''});
        set(h(1),'FaceColor',colormap(labels(1),:));
    end
    print('-djpeg','-r7',[pwd strcat('/icons_v4/',num2str(i),'.jpg')]);
    close();
end
end

