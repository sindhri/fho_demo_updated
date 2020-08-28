%20130625, fixed a couple bugs, should be cell(n,1) instead of cell(n)
%20130529, use struct as output, ITC_config as input

%20130226, used alleeg as input
%output all_ERSP, all_ITC, n_freq*n_time*n_cond*n_subj
%need to modify the way of getting subject id;
%20140829, added chan_list in the struct

function ITC_struct = ITC_calculation_struct(alleeg, dataset_name, chan_list)


EEG = alleeg(1);
id = cell(length(alleeg),1);
etimes = EEG.times;
n_cond = size(EEG.category_names_count,1);

[freqs, n_freqs, n_times, calculation_time_range] = ITC_config(etimes);

if nargin==1
    dataset_name = '';
end

if nargin ==1 || nargin ==2
    chan_list = read_channelclusters;
    chan_list = chan_list{1};
end

calculation_datapoint_range = adjust_range(calculation_time_range,etimes);
datapoint_start = calculation_datapoint_range(1);
datapoint_end = calculation_datapoint_range(2);

fprintf('analysis is conducted on the following channel cluster\n');
for i = 1:length(chan_list)
    fprintf('%d\t',chan_list(i));
end
fprintf('\n');


n_subj = length(alleeg);

all_ERSP = zeros(n_freqs, n_times, n_cond, n_subj);

all_ITC_z = zeros(n_freqs, n_times, n_cond, n_subj);


for i = 1:n_subj
    EEG = alleeg(i);
    fprintf('processing %s\n',EEG.id);
    id{i} = EEG.id;
    category_names_count = EEG.category_names_count;
    if i==1
        n_category = size(category_names_count,1);
        category = cell(n_category,1);
    end
    
    for j = 1:n_category
        trial_index = category_names_count{j,3};
        if i==1
            category{j} = category_names_count{j,1};
        end
        [ERSP,ITC,~,times,freqs]=newtimef(mean(EEG.data(chan_list,...
            datapoint_start:datapoint_end,trial_index),1), ...
        datapoint_end - datapoint_start + 1,calculation_time_range,...
        EEG.srate, [3, 0.5], 'nfreqs',n_freqs, 'freqs', freqs,...
       'timesout',n_times,'baseline',[-EEG.baseline,0],'plotitc','off',...
       'plotersp','off');

       ITC=abs(ITC);       
       ITC_z = ITC_r_to_z(ITC);

       all_ERSP(:,:,j,i) = ERSP;
       all_ITC_z(:,:,j,i) = ITC_z;
    end
end

ITC_struct.name = dataset_name;
ITC_struct.ERSP = all_ERSP;
ITC_struct.ERSP_mean = mean(all_ERSP,4);
ITC_struct.ITC = all_ITC_z;
ITC_struct.ITC_mean = mean(all_ITC_z,4);
ITC_struct.id = id;
ITC_struct.category = category;
ITC_struct.times = times;
ITC_struct.freqs = freqs;
ITC_struct.srate = EEG.srate;
ITC_struct.nfreqs = n_freqs;
ITC_struct.ntimes =n_times;
ITC_struct.baseline = EEG.baseline;
ITC_struct.ERSP_category = cell(n_category,1);
ITC_struct.ITC_category = cell(n_category,1);
for i = 1:n_category
    ITC_struct.ERSP_category{i,1} = [dataset_name ' ERSP ' category{i}];
    ITC_struct.ITC_category{i,1} = [dataset_name ' ITC ' category{i}];
end
ITC_struct.chan_list = chan_list;
end






function [index_range_of_interest, ...
    range_of_interest_adjusted]= adjust_range(range_of_interest,list)

index_range_of_interest = zeros(size(range_of_interest));

range_of_interest_adjusted = range_of_interest;

adjusted = 0;
for i = 1:size(range_of_interest,1)
    for j = 1:size(range_of_interest,2)
        target = range_of_interest(i,j);
        [index,target_adjusted] = find_index(target,list);
        index_range_of_interest(i,j)= index;
        range_of_interest_adjusted(i,j) = target_adjusted;
        if target ~= target_adjusted
            adjusted = 1;
        end
    end
end

fprintf('range of interest');
if adjusted == 1
    fprintf(' adjusted to: ');
end
fprintf('\n');
for i = 1:size(range_of_interest,1)
    for j = 1:size(range_of_interest,2)
        if mod(j,2) == 1
            fprintf('from ');
        else
            fprintf(' to ');
        end
        fprintf('%d',range_of_interest_adjusted(i,j));
    end
fprintf('\n');
end

end

function [index, target_adjusted] = find_index(target, list)
index = 0;
for i = 1:length(list)-1
    diff = list(i)-target;
    if abs(list(i+1) - target) > abs(diff)
        index = i;
        target_adjusted = list(i);
        break;
    end
end
if index==0
    index = length(list);
    target_adjusted = list(length(list));
end
end