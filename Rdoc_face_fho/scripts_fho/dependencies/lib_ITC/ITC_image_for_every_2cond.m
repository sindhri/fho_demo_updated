%20150410
%wrote for a 6cond data,plot every 2 cond pair

function ITC_image_for_every_2cond(IE)
    ncond = length(IE.category_names);
    if mod(ncond,2)~=0
        fprintf('condition not in pairs, abort\n');
        return
    end
    
    times = IE.times;
    freqs = IE.freqs;
    
    data = IE.ERSP_mean;
    diff(:,:,1) = data(:,:,1)-data(:,:,2);
    diff(:,:,2) = data(:,:,3)-data(:,:,4);
    diff(:,:,3) = data(:,:,5)-data(:,:,6);
    limit_ERSP = [min(min(min(data))),max(max(max(data)))];
    diff_limit_ERSP = [min(min(min(diff))),max(max(max(diff)))];
    
    ngraph = ncond/2;
    
    for i = 1:ngraph
        current_pair = i*2-1:i*2;
        titlename=['ERSP' int2str(current_pair)];
        images_for_2cond_single_with_title(times,freqs,data(:,:,current_pair),IE.ERSP_category(current_pair),limit_ERSP,...
    diff_limit_ERSP,titlename);
    end


    data = IE.ITC_mean;
    diff(:,:,1) = data(:,:,1)-data(:,:,2);
    diff(:,:,2) = data(:,:,3)-data(:,:,4);
    diff(:,:,3) = data(:,:,5)-data(:,:,6);

    limit_ITC = [min(min(min(data))),max(max(max(data)))];
    diff_limit_ITC = [min(min(min(diff))),max(max(max(diff)))];

    
    for i = 1:ngraph
        current_pair = i*2-1:i*2;
        titlename=['ITC' int2str(current_pair)];
        images_for_2cond_single_with_title(times,freqs,data(:,:,current_pair),IE.ITC_category(current_pair),limit_ITC,...
    diff_limit_ITC,titlename);
    end
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

function images_for_2cond_single_with_title(times, freqs, data, cond_names,limit,...
    diff_limit,titlename)

fontsize = 15;

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

figure;

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
saveas(gcf,titlename,'pdf');
close;
end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 2;
set(h,'position',size2);
end
