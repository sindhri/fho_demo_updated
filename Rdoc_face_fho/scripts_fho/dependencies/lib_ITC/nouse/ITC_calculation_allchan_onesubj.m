%20130625, fixed a couple bugs, should be cell(n,1) instead of cell(n)
%20130529, use struct as output, ITC_config as input

%20130226, used alleeg as input
%output all_ERSP, all_ITC, n_freq*n_time*n_cond*n_subj
%need to modify the way of getting subject id;

function ITC_struct = ITC_calculation_allchan_onesubj(alleeg, dataset_name)


EEG = alleeg(1);
id = cell(length(alleeg),1);
etimes = EEG.times;
n_cond = size(EEG.category_names_count,1);

[freqs, n_freqs, n_times, calculation_time_range] = ITC_config(etimes);

if nargin==1
    dataset_name = '';
end

calculation_datapoint_range = ITC_adjust_range(calculation_time_range,etimes);
datapoint_start = calculation_datapoint_range(1);
datapoint_end = calculation_datapoint_range(2);


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