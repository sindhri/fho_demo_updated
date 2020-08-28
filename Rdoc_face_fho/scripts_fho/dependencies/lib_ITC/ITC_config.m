function [freqs, n_freqs, n_times, calculation_time_range] = ITC_config(etimes)    

    freqs = [4,30];
    n_freqs = 2*(freqs(2)-freqs(1))+1;
    n_times = 290;
    calculation_time_range = [etimes(1),etimes(length(etimes))];

end