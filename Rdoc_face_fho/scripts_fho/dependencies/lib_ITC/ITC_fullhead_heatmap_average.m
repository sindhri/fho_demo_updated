%plot the average over some time ranges
%ALLEEG is a fake EEG struction for oscilaltion values
%time_ranges = [0,150;150,350,350,550;550,750;750,1050;1050,1350]
%only for 2 cond+diff ALLEEG

%todo, modify scale

function ITC_fullhead_heatmap_average(ALLEEG,time_ranges,print_labels)

nplots = size(time_ranges,1);
ncond = length(ALLEEG);
if ncond~=3
    fprintf('program is only designed for 2 cond+difference\n');
    return
end
times = ALLEEG(1).times;
time_positions = find_valid_pos(time_ranges,times);
chanlocs = ALLEEG(1).chanlocs;
nchan = size(ALLEEG(1).data,1);
data = zeros(nchan,nplots*2);
data_diff = zeros(nchan,nplots);

%for i = 1:2
%    figure;
%    for j = 1:nplots
%        data(:,(i-1)*nplots+j) = mean(ALLEEG(i).data_avg(:,time_positions(j,1):time_positions(j,2)),2);
%        topoplot(data,chanlocs);
%    end
%end

data_mean = mean([ALLEEG(1).mean, ALLEEG(2).mean]);
data_temp = [ALLEEG(1).data_avg, ALLEEG(2).data_avg];
data_std = std(data_temp(:));
data_abs = max(abs(data_mean - 2*data_std), abs(data_mean+2*data_std));
data_limit = [-data_abs,data_abs];

%data_limit(1) = min(min(data));
%data_limit(2) = max(max(data));

%for i=3
%    for j=1:nplots
%        data_diff(:,j) = mean(ALLEEG(i).data_avg(:,time_positions(j,1):time_positions(j,2)),2);
%    end
%end

%data_diff_limit(1) = min(min(data_diff));
%data_diff_limit(2) = max(max(data_diff));

res = get(0,'screensize');

division = ncond+2;
colorbar_width_param = 0.02; 
figure_y_position = [res(4)*0.8, res(4)*0.35,0];
figure_limit = [data_limit;data_limit;ALLEEG(3).limit];
for i = 1:ncond
    f = figure;
        set(f,'position',[0,figure_y_position(i),res(3),res(4)/division]);
    for j = 1:nplots
        a(j) = subplot(1,nplots,j);
        data_plot= mean(ALLEEG(i).data_avg(:,time_positions(j,1):time_positions(j,2)),2);
        if print_labels==0
            topoplot(data_plot,chanlocs,'maplimits',figure_limit(i,:));
        else
            topoplot(data_plot,chanlocs,'maplimits',figure_limit(i,:),'electrodes','numbers');
        end
        title([int2str(time_ranges(j,1)) 'to' int2str(time_ranges(j,2))]);
        axcopy;
    end
    b = colorbar;
    pos = get(a(nplots),'position');
    set(b,'position',[pos(1)+0.14,pos(2),colorbar_width_param,pos(4)],'clim',figure_limit(i,:));
    t = suptitle(ALLEEG(i).setname);
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
