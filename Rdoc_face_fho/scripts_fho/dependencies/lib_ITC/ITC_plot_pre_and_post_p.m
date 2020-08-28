function ITC_plot_pre_and_post_p


filename1 = uigetfile('.txt','choose the pre-FDR p table file');
filename2 = uigetfile('.txt','choose the post-FDR p table file');

[p_pre, frequency_pre, time_start_pre, ...
    time_end_pre, category_names_pre,type_pre]=ITC_read_ptable_columns(filename1);

[p_post, frequency_post, time_start_post, ...
    time_end_post, category_names_post,type_post]=ITC_read_ptable_columns(filename2);

a = isequal(frequency_pre,frequency_post);
b = isequal(time_start_pre,time_start_post);
c = isequal(time_end_pre,time_end_post);
if (a==0 || b==0 || c==0 || strcmp(type_pre, type_post)==0)==1
    fprintf('double check the files you chose and try it again\n');
    return
end

n = length(category_names_pre);
figure;

extra_names = {'pre-FDR','post-FDR'};

for j = 1:length(extra_names)
    for i = 1:n
        if j==1
            [p_reformat,frequency_reformat,time_start_reformat,...
                time_end_reformat] = ITC_variable_to_cases(p_pre(i,:), frequency_pre,...
                time_start_pre, time_end_pre);
        else
            [p_reformat, frequency_reformat,time_start_reformat,...
                time_end_reformat] = ITC_variable_to_cases(p_post(i,:), frequency_post,...
                time_start_post, time_end_post);
        end
        
        if j==1
            subplot(2,n,i);
        else
            subplot(2,n,i+n);
        end
        ITC_plot_p_image(time_start_reformat,frequency_reformat,p_reformat);
        title([type_pre '  '  category_names_pre{i} '  ' extra_names{j} '  p values']);
    end
end


