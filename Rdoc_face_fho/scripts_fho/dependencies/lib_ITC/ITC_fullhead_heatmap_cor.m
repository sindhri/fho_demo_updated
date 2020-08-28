%20141202
%makes heatmap provided the ALLEEG structure
%each EEG is for a condition
%EEG.data dimension follows nchanxntimexnsubj
%items are the time point for plotting

%20150504, correlation map

function ITC_fullhead_heatmap_cor(ALLEEG, items,print_labels)

if nargin==2
    print_labels = 0;
end

ncond = length(ALLEEG);
nplots = length(items);
chanlocs = ALLEEG(1).chanlocs;
item_pos = find_valid_pos(items,ALLEEG(1).times);

limit_cor = [min(ALLEEG(1).cor_range(1),ALLEEG(2).cor_range(1)),...
    max(ALLEEG(1).cor_range(2),ALLEEG(2).cor_range(2))];

%correlation map
res = get(0,'screensize');
division = ncond+2;
colorbar_width_param = 0.015; 

figure_y_position = [res(4)*0.8, res(4)*0.35,0];
figure_limit = [limit_cor;limit_cor;ALLEEG(3).cor_range];


%for r
%for i = 1:ncond
%    f = figure;
%    set(f,'position',[0,figure_y_position(i),res(3),res(4)/division]);
%    for j = 1:nplots
%        a(j) = subplot(1,nplots,j);
%        data_plot= ALLEEG(i).data_cor(:,item_pos(j));
%        topoplot(data_plot,chanlocs,'maplimits',figure_limit(i,:));
%        title([int2str(items(j)) ' ms']);
%    end
%    b = colorbar;
%    pos = get(a(nplots),'position');
%    set(b,'position',[pos(1)+0.06,pos(2),colorbar_width_param,pos(4)],'clim',figure_limit(i,:));
%    t = suptitle(ALLEEG(i).setname_cor);
%    set(t,'interpreter','none');
%end

%plot p
bmap= zeros(20,3);
bmap(1,:)=[1,0,0];
bmap(2,:)=[1,1,0];
bmap(3:20,1)=1;
bmap(3:20,2)=1;
bmap(3:20,3)=1;
limit_p = [0,1];

for i = 2:3
    f = figure;
    set(f,'position',[0,figure_y_position(i),res(3),res(4)/division]);
    for j = 1:nplots
        a(j) = subplot(1,nplots,j);
        data_plot= ALLEEG(i).data_p(:,item_pos(j));
        topoplot(data_plot,chanlocs,'maplimits',limit_p,'colormap',bmap);
        title([int2str(items(j)) ' ms']);
    end
    b = colorbar;
    pos = get(a(nplots),'position');
    set(b,'position',[pos(1)+0.06,pos(2),colorbar_width_param,pos(4)],...
        'clim',limit_p,'XTickLabel',{'0','0.05','0.1','','0.2','',...
        '0.3','','0.4','','0.5','','0.6','','0.7','','0.8','','0.9','','1'});
    t = suptitle(ALLEEG(i).setname_p);
    set(t,'interpreter','none');
end

end

function [items_pos, items_adjusted] = find_valid_pos(items,list)
    n = length(list);
    items_pos = round( (items-list(1))/(list(n)-list(1)) * (n-1))+1;
    items_pos(find(items_pos<1))=1;
    items_pos(find(items_pos>n))=n;
    items_adjusted = list(items_pos);
    
    for i = 1:size(items,1)
        for j = 1:size(items,2)
            if items(i,j)~=items_adjusted(i,j)
                fprintf('time %d adjusted to %d\n', items(i,j),items_adjusted(i,j));
            end
        end
    end
end