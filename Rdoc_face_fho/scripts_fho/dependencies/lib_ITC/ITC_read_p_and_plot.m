function ITC_read_p_and_plot

[p_all, frequency, time_start, ...
    time_end, category_names,type]=ITC_read_ptable_columns;

for i = 1:length(category_names)
    
    [p_reformat, frequency_reformat,time_start_reformat,...
        time_end_reformat] = ITC_variable_to_cases(p_all(i,:), frequency,...
        time_start, time_end);
    figure;
    ITC_plot_p_image(time_start_reformat,frequency_reformat,p_reformat);

    title(category_names{i});
end