%data_struct is from ITC_calculation_struct
%name_group_info is used to identify groups, eg, exposed, control
%20140908, pulled in internal functions
%20140909, added limit
%20141009, plot all conditions, 3 in a graph, but only on one channel
%20150110, added freq_range as an optional input. only plot 62-100hz so
%that the plot is not overpowered by signals in lower frequencies.
%20150410, modify it to the new standard using IE.montage_name,
%IE.montage_channel
%also modify it to fit just one montage, and all the frequency
function ITC_images_for_6cond2(data_struct)

ERSP =data_struct.ERSP_mean; %3 dimension, freqs x times x cond
ITC = data_struct.ITC_mean; %3 dimension, freqs x times x cond

times = data_struct.times;
freqs = data_struct.freqs;

limit_ERSP = find_3d_limit(ERSP);
limit_ITC = find_3d_limit(ITC);

nc = length(data_struct.category_names);
channame = data_struct.montage_name;
ERSP_labels = cell(1);
ITC_labels = cell(1);
for i = 1:nc
    ERSP_labels{i} = [channame ' ' data_struct.ERSP_category{i}];
    ITC_labels{i} = [channame ' ' data_struct.ITC_category{i}];
end
%ERSP
titlename = [channame ' ERSP'];
images_for_6cond_single(times,freqs,ERSP,ERSP_labels,titlename,limit_ERSP); 
%ITC
titlename = [channame ' ITC'];
images_for_6cond_single(times,freqs,ITC,ITC_labels,titlename,limit_ITC);
end


function [items_pos, items_adjusted] = find_valid_pos(items,list)
    n = length(list);
    items_pos = round( (items-list(1))/(list(n)-list(1)) * (n-1))+1;
    items_pos(find(items_pos<1))=1;
    items_pos(find(items_pos>n))=n;
    items_adjusted = list(items_pos);
end

%data, freqs x times x cond(3)
%plot each condition
%doesn't matter how many conditions, but need to adjust size

function images_for_6cond_single(times, freqs, data, cond_names,titlename,limit)

n_cond = size(data,3);
tick = 100;
xtick_min = ceil(times/tick)*tick;
xtick_max = ceil(times(length(times))/tick)*tick;

if n_cond ~= length(cond_names)
    fprintf('number of conditions not match\n');
    return;
end

fontsize = 15;

if nargin==4
    limit = [min(min(min(data))),max(max(max(data)))];
end

figure;

%subplot sizes:
%    0.1300    0.1100    0.2134    0.8150
%    0.4108    0.1100    0.2134    0.8150
%    0.6916    0.1100    0.2134    0.8150

%plot condition 1

adjusted_w = 0.25;
adjusted_x = [0.05,0.375,0.7,0.05,0.375,0.7];

for i = 1:n_cond
    h=subplot(2,3,i);
    imagesc(times,freqs,data(:,:,i),limit);
    t=title(cond_names{i},'fontsize',fontsize);
    set(t,'Interpreter','none');
    set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick_min:tick:xtick_max);
    xlabel('Time(ms)');
    if i==1 || i == 4
    ylabel('Frequency(Hz)');
    end
    colorbar;

    size1 = get(h,'position'); %x,
    size1(1) = adjusted_x(i);
    size1(3) = adjusted_w;
    set(h,'position',size1);
    if i == n_cond
        set(gcf, 'PaperPosition', [0 0 18 10]); %Position plot at left hand corner with width 5 and height 5.
        set(gcf, 'PaperSize', [18 10]); 
        saveas(gcf,titlename,'pdf');
        close;
    end
end
end


function data_range = find_3d_limit(data)
    data_range = [];
    data_range(1) = min(min(min(data,[],1),[],2),[],3);
    data_range(2) = max(max(max(data,[],1),[],2),[],3);
end