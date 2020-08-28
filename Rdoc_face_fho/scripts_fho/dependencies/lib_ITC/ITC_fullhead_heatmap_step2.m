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
%20171106, select 2 condition and plot the difference

function ITC_fullhead_heatmap_step2(ALLEEG, items,print_labels,selected_conditions,limit_diff)

if length(selected_conditions)~=2
    fprintf('can only select 2 conditions\n');
    return
end
    EEG= ALLEEG(1);
    cond1 = selected_conditions(1);
    cond2 = selected_conditions(2);
    EEG.data = ALLEEG(cond1).data-ALLEEG(cond2).data;
    EEG.data_avg = mean(EEG.data,3);
    EEG.mean = mean(EEG.data_avg(:));
    EEG.std = std(EEG.data_avg(:));
    EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
    EEG.limit = [-EEG.abs,EEG.abs];
    category_diff_name = ['diff(',ALLEEG(cond1).category_name, '-', ALLEEG(cond2).category_name,')'];
    if ~isempty(ALLEEG(1).group_name)
        EEG.setname = strcat(ALLEEG(1).group_name, '_', ALLEEG(1).oscillation_type,'_',ALLEEG(1).name_for_plot,'_',category_diff_name);
    else
        EEG.setname = strcat(ALLEEG(1).oscillation_type,'_',ALLEEG(1).name_for_plot,'_',category_diff_name);
    end
    
    EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];


if ~exist('plot_oscillation','dir')
    mkdir('plot_oscillation');
end

if nargin==4
   limit_diff = EEG.limit;
end

if print_labels == 0
   pop_topoplot(EEG,1,items,EEG.setname,[1,length(items)],'maplimits',limit_diff);
else
   pop_topoplot(EEG,1,items,EEG.setname,[1,length(items)],'maplimits',limit_diff,'electrodes','numbers');
end

    
    set(gcf, 'PaperPosition', [0 0 18 3]); 
    set(gcf, 'PaperSize', [18 3]); 
    if print_labels == 1
        saveas(gcf,['plot_oscillation/' EEG.setname],'fig');
    else
        saveas(gcf,['plot_oscillation/' EEG.setname],'pdf');
    end
    close;
end