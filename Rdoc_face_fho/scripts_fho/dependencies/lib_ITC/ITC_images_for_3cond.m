%IE is from ITC_calculation_struct
%name_group_info is used to identify groups, eg, exposed, control
%20140908, pulled in internal functions
%20140909, added limit
%20160907, added save as pdf
%20181126, added interpret, none

function ITC_images_for_3cond(IE,limit_ERSP,limit_ITC)

if nargin==1
   limit_ERSP = [min(min(min(IE.ERSP_mean))),max(max(max(IE.ERSP_mean)))];
   limit_ITC = [min(min(min(IE.ITC_mean))),max(max(max(IE.ITC_mean)))];
    
end

times = IE.times;
freqs = IE.freqs;

%ERSP
data = IE.ERSP_mean;
titlename=['ERSP_' IE.group_name '_' IE.montage_name];
images_for_3cond_single(times,freqs,data,IE.ERSP_category,...
        limit_ERSP,titlename);

%ITC
data = IE.ITC_mean;
titlename=['ITC_' IE.group_name '_' IE.montage_name];
images_for_3cond_single(times,freqs,data,IE.ITC_category,...
        limit_ITC,titlename);

end



%data, freqs x times x cond(3)
%plot each condition
%doesn't matter how many conditions, but need to adjust size

function images_for_3cond_single(times, freqs, data, cond_names,limit,titlename)

n_cond = size(data,3);
tick = 200;
xtick_min = ceil(times/tick)*tick;
xtick_max = ceil(times(length(times))/tick)*tick;

if n_cond ~= length(cond_names)
    fprintf('number of conditions not match\n');
    return;
end

fontsize = 15;

if ~exist('plot_oscillation','dir')
    mkdir('plot_oscillation');
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
    title(cond_names{i},'fontsize',fontsize,'interpret','none');
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
end

set(gcf, 'PaperPosition', [0 0 18 10]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [18 10]); 
saveas(gcf,['plot_oscillation/' titlename],'pdf');
close;
end