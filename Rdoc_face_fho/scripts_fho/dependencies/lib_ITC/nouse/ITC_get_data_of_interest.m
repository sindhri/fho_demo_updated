%input data of all time and frequency
%input data format, freqs x times x cond x subject

%input time_of_interest, each row is a range, with starting and ending
%point as two columns
%input frequency_of_interest, each row is a range, with starting and ending
%point as two columns

%example
%time_of_interest = [200,350];
%frequency_of_interest = [4,7;8,12;15,30];


%output averaged data within specific time and frequency
%output format n_frequency_of_interest x n_time_of_interest x cond x subj

function [data_of_interest,time_of_interest_adjusted,...
    frequency_of_interest_adjusted ] = ITC_get_data_of_interest(data, ...
    time_of_interest, frequency_of_interest, times, freqs)

[index_time_of_interest, ...
    time_of_interest_adjusted]= ITC_adjust_range(time_of_interest,times);
[index_frequency_of_interest, ...
    frequency_of_interest_adjusted]= ITC_adjust_range(frequency_of_interest,freqs);            

data_of_interest = ITC_get_data_of_interest_using_index(data, ...
    index_time_of_interest, index_frequency_of_interest);

end

