function [data, freqs,times,category_names, type] = ITC_get_value_from_table(message)

if nargin==0
    message = 'choose the table file';
end

filename = uigetfile('.txt',message);
fprintf('file chosen %s \n',filename);

[data_original, frequency, time_start, ...
    time_end, category_names,type]=ITC_read_ptable_columns(filename);

n = length(category_names);
data = cell(n,1);

for i = 1:n
   [data{i},freqs,times,...
        ~] = ITC_variable_to_cases(data_original(i,:), frequency,...
        time_start, time_end);

end

end