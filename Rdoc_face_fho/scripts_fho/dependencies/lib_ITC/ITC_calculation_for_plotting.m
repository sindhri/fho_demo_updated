%20130625, fixed a couple bugs, should be cell(n,1) instead of cell(n)
%20130529, use struct as output, ITC_config as input

%20130226, used alleeg as input
%output all_ERSP, all_ITC, n_freq*n_time*nconds*nsubjs
%need to modify the way of getting subject id;
%20140829, added chan_list in the struct

%20140908, pulled in internal functions so its self run

%20150311, work for more than 1 frequency. renamed some variables. did some
%internal clean up
%20150311, change chan_list into a struct with name and channel fiekds
%changed dataset_name to group_name
%20150414, get group_name from EEG, read_egi
%20150608, added montage name in the ERSP/ITC category_names
%20160907, added test run to determine time points, added freq_limits
%20170320, added output frequency numbers in order to make smoother
%time x frequency images

function ITC_struct = ITC_calculation_for_plotting(alleeg, chan_list,...
    freq_limits,nfreqs)


if nargin ==1
    chan_list = read_channelclusters;
    chan_list = chan_list{1};
end

EEG = alleeg(1);
etimes = EEG.times;
group_name=EEG.group_name;

id = cell(length(alleeg),1);
nconds = size(EEG.category_names_count,1);
nsubjs = length(alleeg);
category_names = EEG.category_names;

%nfreqs = 2*(freq_limits(2)-freq_limits(1))+1;
calculation_time_range = [etimes(1),etimes(length(etimes))];

calculation_datapoint_range = adjust_range(calculation_time_range,etimes);
datapoint_start = calculation_datapoint_range(1);
datapoint_end = calculation_datapoint_range(2);

%test run to find out ntimes, run on channel 1, trial1
[ERSP,~,~,times,freqs]=newtimef(mean(EEG.data(1,...
   datapoint_start:datapoint_end,1),1), ...
   datapoint_end - datapoint_start + 1,calculation_time_range,...
   EEG.srate, [3, 0.5], 'nfreqs',nfreqs, 'freqs', freq_limits,...
   'timesout',3000,'baseline',[-EEG.baseline,0],'plotitc','off',...
   'plotersp','off');

ntimes = size(ERSP,2);
fprintf('\n\nfrom the test run, ntimes is %d\n\n',ntimes);


all_ERSP = zeros(nfreqs, ntimes, nconds, nsubjs);
all_ITC_z = zeros(nfreqs, ntimes, nconds, nsubjs);

for i = 1:nsubjs
    EEG = alleeg(i);
    fprintf('processing %s\n',EEG.id);
    etimes = EEG.times;

    nfreqs = 2*(freq_limits(2)-freq_limits(1))+1;
    calculation_time_range = [etimes(1),etimes(length(etimes))];

    calculation_datapoint_range = adjust_range(calculation_time_range,etimes);
    datapoint_start = calculation_datapoint_range(1);
    datapoint_end = calculation_datapoint_range(2);

    fprintf('analysis is conducted on the following channel cluster\n');
    for j = 1:length(chan_list.channel)
        fprintf('%d\t',chan_list.channel(j));
    end
    fprintf('\n');

    id{i} = EEG.id;
    fid = fopen('record_frequency.txt','a');
    fprintf(fid,'%s%s\t%d\n',group_name,EEG.id,EEG.srate);
    fclose(fid);
    for j = 1:nconds
        trial_index = EEG.category_names_count{j,3};
 
        [ERSP,ITC,~,times,freqs]=newtimef(mean(EEG.data(chan_list.channel,...
            datapoint_start:datapoint_end,trial_index),1), ...
        datapoint_end - datapoint_start + 1,calculation_time_range,...
        EEG.srate, [3, 0.5], 'nfreqs',nfreqs, 'freqs', freqs,...
       'timesout',ntimes,'baseline',[-EEG.baseline,0],'plotitc','off',...
       'plotersp','off');

       ITC=abs(ITC);       
       ITC_z = r_to_z_4d(ITC);

       all_ERSP(:,:,j,i) = ERSP;
       all_ITC_z(:,:,j,i) = ITC_z;
    end
end

ITC_struct.group_name = group_name;
ITC_struct.ERSP = all_ERSP;
ITC_struct.ERSP_mean = mean(all_ERSP,4);
ITC_struct.ITC = all_ITC_z;
ITC_struct.ITC_mean = mean(all_ITC_z,4);
ITC_struct.id = id;
ITC_struct.category_names = category_names;
ITC_struct.times = times;
ITC_struct.freqs = freqs;
ITC_struct.srate = EEG.srate;
ITC_struct.nfreqs = nfreqs;
ITC_struct.ntimes =ntimes;
ITC_struct.baseline = EEG.baseline;
ITC_struct.ERSP_category = cell(nconds,1);
ITC_struct.ITC_category = cell(nconds,1);
for i = 1:nconds
    ITC_struct.ERSP_category{i,1} = [group_name ' ' chan_list.name ' ERSP ' category_names{i}];
    ITC_struct.ITC_category{i,1} = [group_name ' ' chan_list.name ' ITC ' category_names{i}];
end
ITC_struct.montage_name = chan_list.name;
ITC_struct.montage_channel = chan_list.channel;
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



%convert ITC(r) to z

function data_z = r_to_z_4d(data)

data_z = zeros(size(data));

for a = 1:size(data,1)
    for b = 1:size(data,2)
        for c = 1:size(data,3)
            for d = 1:size(data,4)
                data_z(a,b,c,d) = r_to_z(data(a,b,c,d));
            end
        end
    end
end

end

function z = r_to_z(x)

z = 1/2*log((1+x)/(1-x));
end