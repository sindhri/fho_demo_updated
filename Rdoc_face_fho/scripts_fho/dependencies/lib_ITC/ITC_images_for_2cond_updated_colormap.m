%IE is from ITC_calculation_struct
%name_group_info is used to identify groups, eg, exposed, control
%%20140908, pulled in internal functions
%20151029, added mkdir
%20160907, modified title name
%20170320, added colormap information
%for some reason, it happened before, had to put a stop right before
%enlarge.
%otherwise it plots only the difference


function ITC_images_for_2cond_updated_colormap(IE,cmap,limit_ERSP,diff_limit_ERSP,...
    limit_ITC,diff_limit_ITC)

times = IE.times;
freqs = IE.freqs;

%ERSP
data = IE.ERSP_mean;
diff = data(:,:,1)-data(:,:,2);
if nargin==2
    limit_ERSP = [min(min(min(data))),max(max(max(data)))];
    diff_limit_ERSP = [min(min(min(diff))),max(max(max(diff)))];
end
titlename=['ERSP_' IE.group_name '_' IE.montage_name];
images_for_2cond_single(times,freqs,data,IE.ERSP_category,limit_ERSP,...
    diff_limit_ERSP, titlename,cmap);

%ITC
data = IE.ITC_mean;
diff = data(:,:,1)-data(:,:,2);
if nargin==2
    limit_ITC = [min(min(min(data))),max(max(max(data)))];
    diff_limit_ITC = [min(min(min(diff))),max(max(max(diff)))];
end
titlename=['ITC_' IE.group_name '_' IE.montage_name];
images_for_2cond_single(times,freqs,data,IE.ITC_category,limit_ITC,...
    diff_limit_ITC,titlename,cmap);
    
end



%plot the time and frequency plot for each condition, 
%and the difference (cond1-cond2)

%required input: 
%times: generated from newtimef
%freqs: generated from newtimef
%data: freqs x times x cond(2)
%cond_names: {'cond1','cond2'}

%optional input:
%limit, diff_limit: arbitrary range for the plot

%updated xtick for longer segments

function images_for_2cond_single(times, freqs, data, cond_names,limit,...
    diff_limit,titlename,cmap)

fontsize = 14;

diff = data(:,:,1)-data(:,:,2);

ndp = length(times);
tick_interval = 100;
nbasic_xtick = floor((times(ndp)-times(1))/tick_interval);
if nbasic_xtick > 12
    tick_interval = 200;
%    nbasic_xtick = floor((times(ndp)-times(1))/tick_interval);
end

xtick_start = -floor(-(times(1)/tick_interval))*tick_interval;
xtick_end = floor(times(ndp)/tick_interval)*tick_interval;
xtick = xtick_start:tick_interval:xtick_end;

if ~exist('plot_oscillation','dir')
    mkdir('plot_oscillation');
end
figure;

colormap(cmap);

%plot condition 1
h1=subplot(1,3,1);
imagesc(times,freqs,data(:,:,1),limit);
t=title(cond_names{1},'fontsize',fontsize);
set(t,'Interpreter','none');
set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h1,-0.09);

%plot condition 2
h2=subplot(1,3,2);
imagesc(times,freqs,data(:,:,2),limit);
t=title(cond_names{2},'fontsize',fontsize);
set(t,'Interpreter','none');
set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h2,-0.04);

%plot difference
h3=subplot(1,3,3);
imagesc(times,freqs,diff,diff_limit);
t=title([cond_names{1} '-' cond_names{2}],'fontsize',fontsize);
set(t,'Interpreter','none');
set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h3,0);

set(gcf, 'PaperPosition', [0 0 18 10]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [18 10]); 
saveas(gcf,['plot_oscillation/' titlename],'pdf');
close;
end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 2;
set(h,'position',size2);
end
