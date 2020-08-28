function ITC_plot_individual(p,frequency,time_start,time_end)

    
    [n_freqs, n_times] = size(p);

    hold on;
    for i = 1:n_freqs
        for j = 1:n_times
            if p(i,j)<0.05
                plot(time_start(j),frequency(i),'*');
            end
        end
    end
    axis([time_start(1),time_end(n_times),min(frequency)-1,max(frequency)]);
    set(gca,'yTick',floor(min(frequency)):ceil(max(frequency)));
    %problem, ytick wasn't adjusted. 20120913
    hold off;
    grid on;

end