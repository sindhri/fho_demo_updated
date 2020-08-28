%data_struct is from ITC_calculation_struct
%name_group_info is used to identify groups, eg, exposed, control
%20140908, pulled in internal functions
%20140909, added limit
%20141009, plot all conditions, 3 in a graph, but only on one channel

function ITC_images_for_every_3cond(data_struct,channel)

plot_per_page = 3;
ppp = plot_per_page;

ERSP = squeeze(data_struct.ERSP_mean(:,:,:,1,channel)); %3 dimension, freqs x times x cond
ITC = squeeze(data_struct.ITC_mean(:,:,:,1,channel)); %3 dimension, freqs x times x cond

limit_ERSP = find_3d_limit(ERSP);
limit_ITC = find_3d_limit(ITC);

times = data_struct.times;
freqs = data_struct.freqs;

nc = length(data_struct.category_names);
ncycle = floor(nc/ppp);
if rem(nc,ppp) > 0
    ncycle = ncycle + 1;
end

for i = 1:ncycle
    if i==ncycle
        cc = ((i-1)*ppp +1):nc;
    else
        cc = ((i-1)*ppp +1) : i*ppp;
    end
    ERSP_labels = cell(1);
    ITC_labels = cell(1);
    for j =cc
        ERSP_labels{j-cc(1)+1} = [data_struct.channames{channel} ' ' data_struct.ERSP_category{j}];
        ITC_labels{j-cc(1)+1} = [data_struct.channames{channel} ' ' data_struct.ITC_category{j}];
    end
    %ERSP
%    images_for_3cond_single(times,freqs,ERSP(:,:,cc),ERSP_labels,limit_ERSP); 
    %ITC
    images_for_3cond_single(times,freqs,ITC(:,:,cc),ITC_labels,limit_ITC);
end
end


%data, freqs x times x cond(3)
%plot each condition
%doesn't matter how many conditions, but need to adjust size

function images_for_3cond_single(times, freqs, data, cond_names,limit)

n_cond = size(data,3);
tick = 100;
xtick_min = ceil(times/tick)*tick;
xtick_max = ceil(times(length(times))/tick)*tick;

if n_cond ~= length(cond_names)
    fprintf('number of conditions not match\n');
    return;
end

fontsize = 15;

%diff = data(:,:,1)-data(:,:,2);

if nargin==4
    limit = [min(min(min(data))),max(max(max(data)))];
%    diff_limit = [min(min(min(diff))),max(max(max(diff)))];
end

figure;

%subplot sizes:
%    0.1300    0.1100    0.2134    0.8150
%    0.4108    0.1100    0.2134    0.8150
%    0.6916    0.1100    0.2134    0.8150

%plot condition 1

adjusted_w = 0.25;
adjusted_x = [0.05,0.375,0.7];

for i = 1:n_cond
    h=subplot(1,3,i);
    imagesc(times,freqs,data(:,:,i),limit);
    title(cond_names{i},'fontsize',fontsize);
    set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick_min:tick:xtick_max);
    xlabel('Time(ms)');
    if i==1
    ylabel('Frequency(Hz)');
    end
    colorbar;

    size1 = get(h,'position');
    size1(1) = adjusted_x(i);
    size1(3) = adjusted_w;
    set(h,'position',size1);
    if i == n_cond
        set(gcf, 'PaperPosition', [0 0 18 6]); %Position plot at left hand corner with width 5 and height 5.
        set(gcf, 'PaperSize', [18 6]); 
        saveas(gcf,cond_names{1},'pdf');
        close;
    end
end
end


function data_range = find_3d_limit(data)
    data_range = [];
    data_range(1) = min(min(min(data,[],1),[],2),[],3);
    data_range(2) = max(max(max(data,[],1),[],2),[],3);
end