%visualize p file, only 1 type at a time(ITC or ERSP)
%n_times and n_freqs must be evenly distributed
%title_extra is "pre FDR or post FDR"

function [p_reformat,time_start_reformat,time_end_reformat,...
    frequency_reformat] = ITC_visualization(title_extra,filename)

    if nargin <2
        filename = uigetfile('.txt','select the p file to be visualized');
    end
    if  nargin<1
        title_extra = '';
    end
    
    [p_all, frequency, time_start, time_end,...
        category_names,type]=ITC_read_ptable_columns(filename);
    
    for i = 1:size(p_all,1)
        [p_reformat, frequency_reformat,time_start_reformat,...
            time_end_reformat] = ITC_variable_to_cases(p_all(i,:),...
            frequency,time_start, time_end);
        
        %figure
 %       ITC_plot_individual(p_reformat,frequency_reformat,time_start_reformat,...
 %           time_end_reformat);
 %        title([category_names{i} '  ' type]);
 
        figure;
        ITC_plot_p_image(time_start_reformat,frequency_reformat,p_reformat);
        title([category_names{i} '  ' type]);

        if i==1
            p_reformat_all= zeros([size(p_reformat),size(p_all,3)]);
        end
        p_reformat_all(:,:,i) = p_reformat;
    end
    
    ITC_plot_multiple(p_reformat_all,frequency_reformat,...
        time_start_reformat,time_end_reformat,...
    category_names,type,title_extra);
end