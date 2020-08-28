%20141202
%makes heatmap provided the ALLEEG structure
%each EEG is for a condition
%EEG.data dimension follows nchanxntimexnsubj
%items are the time point for plotting

%20151102, added save image. added plot_oscillation folder
%20151102, added manually input limit and limit_diff
%20151215, use EEG.limit instead of EEG.abs. (limit was set to be abs most
%of the time except in the ITC situation)
%20160212, if print channel label, do not close the figure
%20170227, modified to fix 1 condition
%20180711, decide the scale for condition 1, 2, and differences
%automatically, no need of manual adjustment, also print both the labeled
%and nonlabeled version simultanously
%20180716, added limits options

function ITC_fullhead_heatmap_auto(ALLEEG, items,limit,limit_diff)


ncond = length(ALLEEG);

%range = [min([ALLEEG(1).range,ALLEEG(2).range]),...
%    max([ALLEEG(1).range,ALLEEG(2).range])];
if ncond>1
    data_mean = mean([ALLEEG(1).mean, ALLEEG(2).mean]);
    data_temp = [ALLEEG(1).data_avg, ALLEEG(2).data_avg];
    data_std = std(data_temp(:));
    data_abs = max(abs(data_mean - 2*data_std), abs(data_mean+2*data_std));
else
    data_mean = ALLEEG.mean;
    data_temp = ALLEEG.data_avg;
    data_std = std(data_temp(:));
    data_abs = max(abs(data_mean - 2*data_std), abs(data_mean+2*data_std));
end
%limit = [-data_abs,data_abs];

if ~exist('plot_oscillation','dir')
    mkdir('plot_oscillation');
end

if ~exist('plot_oscillation/pdf','dir')
    mkdir('plot_oscillation/pdf');
end

if ~exist('plot_oscillation/fig','dir')
    mkdir('plot_oscillation/fig');
end

temp = max([abs(ALLEEG(1).limit(1)),abs(ALLEEG(2).limit(1)),...
    abs(ALLEEG(1).limit(2)),abs(ALLEEG(2).limit(2))]);
if isfield(ALLEEG(1),'oscillation_type')
    if strcmp(ALLEEG(1).oscillation_type,'ERSP')==1
        oscillation_type = 'ERSP';
    else
        oscillation_type = 'ITC';
    end
else
    if ALLEEG(1).setname(1)=='E' %ERSP %old files
        oscillation_type = 'ERSP'; 
    else
        oscillation_type = 'ITC';
    end
end

if nargin==2
    if strcmp(oscillation_type,'ERSP')==1
        limit = [-temp,temp];
    else
        limit = [0,temp]; %ITC
    end
end

if nargin==2
    limit_diff = ALLEEG(3).limit;
end

paper_size = [18 3];
paper_position = [0 0 18 3];
for i = 1:ncond
    if i==1 || i==2
    %cannot use 'absmax' or'maxmin', has to either omit it or use a
    %specific limit, otherwise it only applies the limit on the very last
    %graph
       pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit);
       set(gcf, 'PaperPosition', paper_position); 
       set(gcf, 'PaperSize', paper_size); 
       saveas(gcf,['plot_oscillation/pdf/' ALLEEG(i).setname],'pdf');
        close;

       pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit,'electrodes','numbers');
       set(gcf, 'PaperPosition', paper_position); 
       set(gcf, 'PaperSize', paper_size); 
        saveas(gcf,['plot_oscillation/fig/' ALLEEG(i).setname],'fig');
       close;

    else

       pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit_diff);
       set(gcf, 'PaperPosition', paper_position); 
       set(gcf, 'PaperSize', paper_size); 
       saveas(gcf,['plot_oscillation/pdf/' ALLEEG(i).setname],'pdf');
        close;

       pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit_diff,'electrodes','numbers');
       set(gcf, 'PaperPosition', paper_position); 
       set(gcf, 'PaperSize', paper_size); 
        saveas(gcf,['plot_oscillation/fig/' ALLEEG(i).setname],'fig');
        close;
    end

end
end