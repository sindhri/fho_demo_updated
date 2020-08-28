function ITC_get_and_plot_all_category_Fd()

[F, freqs,times,category_names, ...
    type] = ITC_get_value_from_table('choose the F value table');
[d, freqs,times,category_names, ...
    type] = ITC_get_value_from_table('choose the d value table');

n = length(category_names);

figure;
nrow = 2;
ncol = n;

for i = 1:nrow
    for j = 1:ncol
        position = (i-1)*ncol + j;
        subplot(nrow,ncol,position);
        if i==1
            ITC_plot_Fd_image(times,freqs,F{j});
            title([type '   ' category_names{j} '   F values']);
        else
            ITC_plot_Fd_image(times,freqs,d{j});
            title([type '   ' category_names{j} '   d values']);
        end
    end
end