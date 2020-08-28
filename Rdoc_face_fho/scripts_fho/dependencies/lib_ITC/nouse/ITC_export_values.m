%data is in 4 dimention from the calculation of ERSP or ITC
%frequency x time x condition x subject
%datatype is ERSP or ITC, use for column name

%export a file written with subject x all conditions

%20121031, can use fraction as frequency

function A = ITC_export_values(data, freqs, times, subjects,...
    condition_list,datatype,time_interval)

%time_interval = 16; %every 16 ms, or every 4 data points
dpt_interval = 4;
[n_freqs, ~, n_conds, n_subjs] = size(data);
rownames = cell(n_subjs,1);

if n_subjs ~= length(subjects)
    fprintf('number of subjects mismatch, abort/n');
    return
end

for i = 1:n_subjs
    rownames{i,1} = int2str(subjects(i));
end

[data_new, times_new] = ITC_split_times(data, times, time_interval);
n_times = length(times_new);
data_array = zeros(n_subjs,1);

m = 1;
for a = 1:n_conds
    for b = 1:n_freqs
        for c = 1:n_times
            data_array(:,m) = squeeze(data_new(b,c,a,:));
            colnames{m,1} = generate_colname(datatype,condition_list{a},...
                freqs(b),times_new(c),time_interval,dpt_interval);
            if m == 1
                A = dataset(data_array,'ObsNames',rownames,'VarNames',colnames{m});
            else
                A = cat(2,A,dataset(data_array(:,m),'ObsNames',rownames,'VarNames',colnames{m}));
            end
            
            m = m + 1;
        end
    end
end
[filename,pathname] = uiputfile('*.txt',['save the exported ' datatype ' as: ']);
export(A,'file',[pathname, filename]);
end

function colname = generate_colname(datatype,condition_name,...
    single_frequency,single_time,time_interval,dpt_interval)
            
    time_start = single_time;
    time_end = time_start + time_interval - dpt_interval;
    name_frequency = num2str(single_frequency);
    for i = 1:length(name_frequency)
        if strcmp(name_frequency(i),'.')==1
           name_frequency(i)='p';
            break
        end
    end
    colname = [condition_name '_' datatype '_', name_frequency,...
         'Hz',int2str(time_start) '_' int2str(time_end) 'ms'];

end
