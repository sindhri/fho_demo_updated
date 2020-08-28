%note, input p has to be a vector

function [p_reformat, frequency_reformat,time_start_reformat,...
    time_end_reformat] = ITC_variable_to_cases(p, frequency,...
    time_start, time_end)

    n_times = length(find(frequency==frequency(1)));
    n_freqs = length(p)/n_times;
    p_reformat = zeros(n_freqs,n_times);
    time_start_reformat = time_start(1:n_times);
    time_end_reformat = time_end(1:n_times);

    for j = 1:n_freqs
        col_start = (j-1)*n_times+1;
        col_end = j*n_times;
        p_reformat(j,:) = p(col_start:col_end);
        frequency_reformat(j) = frequency(col_start);
    end
end