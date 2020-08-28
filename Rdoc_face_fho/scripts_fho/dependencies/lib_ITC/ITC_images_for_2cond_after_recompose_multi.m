%20180316
%IE is the either ERSP or ITC after recompose
%chan_cluster.channel
%chan_cluster.montage_name
%only for ERSP
%20180427
%channel is the 3rd dimension if recompose from multiple condiitons
%together
%instead of from the IE that has all the conditions
%added oscillation_type, for either ERSP, or ITC
%only input the limit for the specific oscillation_type
%added able to pick 2 out of many conditions, condition is the 3rd
%dimension
function tfplot = ITC_images_for_2cond_after_recompose_multi(IE,chan_cluster,...
    oscillation_type, condition_of_interest, limit_cond,...
        limit_cond_diff)

    if length(condition_of_interest)~=2
        fprintf('can only plot 2 conditions and their difference.\n');
        return
    end
    
    tfplot = IE;
    tfplot = rmfield(tfplot,'channames');
    tfplot.montage_name = chan_cluster.montage_name;
    tfplot.nbchan = length(chan_cluster.channel);
    %20180427 change channel to the 3rd dimension 
    %tfplot.ERSP_mean = squeeze(mean(mean(IE.ERSP(:,:,:,chan_cluster.channel,:),4),5));
    times = tfplot.times;
    freqs = tfplot.freqs;

    
    %for either ERSP or ITC, but not both
    oscillation_mean_name = [oscillation_type '_mean'];
    tfplot.(oscillation_mean_name) = squeeze(mean(mean(IE.(oscillation_type)(:,:,chan_cluster.channel,:,:),3),5));
    data = tfplot.(oscillation_mean_name);
    data = data(:,:,condition_of_interest);
    diff = data(:,:,1)-data(:,:,2);
    if nargin==4
        limit_cond = [min(min(min(data))),max(max(max(data)))];
        limit_cond_diff = [min(min(min(diff))),max(max(max(diff)))];    
    end
    condition_names_in_title = [tfplot.category_names{condition_of_interest(1)} '_' tfplot.category_names{condition_of_interest(2)}];
    if ~isempty(tfplot.group_name)
        titlename=[oscillation_type '_' tfplot.group_name '_' tfplot.montage_name '_' condition_names_in_title];
    else
        titlename=[oscillation_type '_' tfplot.montage_name '_' condition_names_in_title];
    end
    plot_cond_names{1} = [oscillation_type '_' tfplot.category_names{condition_of_interest(1)}];
    plot_cond_names{2} = [oscillation_type '_' tfplot.category_names{condition_of_interest(2)}];
    plot_cond_diff_names = [plot_cond_names{1} '_' plot_cond_names{2}];
    
    images_for_2cond_single(times,freqs,data,diff,...
        plot_cond_names,plot_cond_diff_names,limit_cond,...
        limit_cond_diff, titlename);
   

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
%added diff 201800427, cond_names_diff
function images_for_2cond_single(times, freqs, data,diff,...
cond_names, cond_names_diff,limit,...
    diff_limit,titlename)

fontsize = 15;

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
t=title(cond_names_diff,'fontsize',fontsize);
set(t,'Interpreter','none');
set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h3,0);

set(gcf, 'PaperPosition', [0 0 18 10]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [18 10]); 
saveas(gcf,['plot_tf/' titlename],'pdf');
close;
end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 2;
set(h,'position',size2);
end
