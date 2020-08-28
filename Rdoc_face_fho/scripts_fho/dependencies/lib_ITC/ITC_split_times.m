%split 4ms apart times into nx4ms apart, starting from times==0
%input data, frequency x times x condition x subject
%time_interval must be multiples of single time
%times is the time series, must be evenly distributed

%20120829, fixed a bug of missing one time in the matrix

function [data_new, times_new] = ITC_split_times(data, times, time_interval)

unit = times(2)- times(1);

if mod(time_interval, unit) ~= 0
    fprintf('time interval must be a multiple of %d ms\n', unit);
    return
else
    dpt_interval = time_interval/unit;
end

[n_freqs, n_times, n_conds, n_subjs] = size(data);

start = find(times==0);

data_new = zeros(n_freqs, 1, n_conds, n_subjs);
temp = zeros(n_freqs, dpt_interval, n_conds, n_subjs);
times_new = 0;
m = 1;
n = 1;

i=start;
while(i<=n_times)
    if i+dpt_interval-1<=n_times
        for j = 1:dpt_interval
            current_time = i+j-1;
            temp(:,j,:,:) = data(:,current_time,:,:);
        end
    else
        break;
    end
    data_new(:,m,:,:) = mean(temp,2);
    times_new(m) = times(i);
    m = m + 1;
    temp = zeros(n_freqs, dpt_interval, n_conds, n_subjs);
    i = i+dpt_interval;
end
