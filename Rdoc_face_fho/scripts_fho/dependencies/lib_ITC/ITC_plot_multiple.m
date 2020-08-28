function ITC_plot_multiple(p,frequency,time_start,time_end,...
    category_names,type,title_extra)

    [n_freqs,n_times,n_cond] = size(p);
    symbols = {'b*','mv','g+','ro','kh','cp','ys'};
    legend_names = {};
    n = 0;
    figure;
    hold on
    compensation_bin = ((max(frequency) - min(frequency)))*0.015;
    if mod(n_cond,2)==0
        compensation = -compensation_bin*n_cond/2:compensation_bin:compensation_bin*n_cond;
    else
        compensation = -compensation_bin*(n_cond-1)/2:compensation_bin:compensation_bin*(n_cond-1)/2;
    end
    for m = 1:n_cond
        if ~isempty(find(p(:,:,m)<0.05,1))
            n = n + 1;
            legend_names{n} = category_names{m};
            plot_x = [];
            plot_y = [];
            for i = 1:n_freqs
                for j = 1:n_times
                    if p(i,j,m)<0.05
                        plot_x = [plot_x time_start(j)];
                        plot_y = [plot_y frequency(i)+compensation(m)];
                    end
                end
            end
            plot(plot_x,plot_y,symbols{m});
        end
    end
    axis([time_start(1),time_end(n_times),min(frequency)-1,max(frequency)+1]);
    title([title_extra '   ' type]);
    legend(legend_names);
    xlabel('Time (ms)');
    ylabel('Frequency (Hz)')
    hold off;
    grid on;
end