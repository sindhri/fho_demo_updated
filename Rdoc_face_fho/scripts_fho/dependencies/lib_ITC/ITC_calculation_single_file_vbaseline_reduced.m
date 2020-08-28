%20130625, fixed a couple bugs, should be cell(n,1) instead of cell(n)
%20130529, use struct as output, ITC_config as input

%20130226, used alleeg as input
%output all_ERSP, all_ITC, n_freq*n_time*n_cond*n_subj
%need to modify the way of getting subject id;
%20140829, added chan_list in the struct

%20140908, pulled in internal functions so its self run
%20141009, added full head support
%20150917, added channel name display for each subject

%20151029, make a result folder and save the results, separate for each
%individual

%20151104, modify it to work on only one single EEG, removed ITC_config

%category name is wrong, should only be one category
%can't decide whether to save all categories or just one
%to what extend i want to go through the trouble of picking up all the
%information from individual files later

%20151210, after thinking for a long time, decided to save one struct per
%subject per session and store it as a file. 
%20160608, added output foldername
%20170608, added vbaseline,usually [-600,-100]
%20170918, record vbaseline in oscillation result
%20180509, added induced ERSP/ITC

function ITC_calculation_single_file_vbaseline_reduced(EEG,freq_limits,foldername)

if nargin==2
    foldername = [pwd '/result/'];
end

etimes = EEG.times;
group_name = EEG.group_name;

n_freqs = 2*(freq_limits(2)-freq_limits(1))+1;
calculation_time_range = [etimes(1),etimes(length(etimes))];


calculation_datapoint_range = adjust_range(calculation_time_range,etimes);
datapoint_start = calculation_datapoint_range(1);
datapoint_end = calculation_datapoint_range(2);

nbchan = EEG.nbchan;
fprintf('analysis is conducted on %d channels\n',nbchan);
channames = cell(1);
for i = 1:nbchan
    channames{i} = EEG.chanlocs(i).labels;
end
if nbchan < 10
    for i = 1:nbchan
        fprintf('%s\n',channames{i});
    end
    fprintf('\n');
else
    fprintf('from %s to %s\n\n',channames{1}, channames{nbchan});
end



%test run to find out n_times, run on channel 1, trial1
[ERSP,~,~,times,freqs]=newtimef(mean(EEG.data(1,...
   datapoint_start:datapoint_end,1),1), ...
   datapoint_end - datapoint_start + 1,calculation_time_range,...
   EEG.srate, [3, 0.5], 'nfreqs',n_freqs, 'freqs', freq_limits,...
   'timesout',3000,'baseline',EEG.vbaseline,'plotitc','off',...
   'plotersp','off');

n_times = size(ERSP,2);
fprintf('\n\nfrom the test run, n_times is %d\n\n',n_times);


category_names = EEG.category_names;
nconds = length(category_names);


all_ERSP = zeros(n_freqs, n_times, nconds, nbchan);
all_ITC_z = zeros(n_freqs, n_times, nconds, nbchan);
all_iERSP = zeros(n_freqs, n_times, nconds, nbchan);
all_iITC_z = zeros(n_freqs, n_times, nconds, nbchan);

ITC_struct_base.group_name = group_name;
ITC_struct_base.freqs = freqs;
ITC_struct_base.times = times;
ITC_struct_base.srate = EEG.srate;
ITC_struct_base.nfreqs = n_freqs;
ITC_struct_base.ntimes =n_times;
ITC_struct_base.baseline = EEG.baseline;
ITC_struct_base.channames = channames;
ITC_struct_base.nbchan = nbchan;
ITC_struct_base.category_names = EEG.category_names;
ITC_struct_base.ERSP_category = cell(nconds,1);
ITC_struct_base.ITC_category = cell(nconds,1);
ITC_struct_base.iERSP_category = cell(nconds,1);
ITC_struct_base.iITC_category = cell(nconds,1);
ITC_struct_base.vbaseline= EEG.vbaseline;
for i = 1:nconds
    ITC_struct_base.ERSP_category{i,1} = [group_name ' ERSP ' category_names{i}];
    ITC_struct_base.ITC_category{i,1} = [group_name ' ITC ' category_names{i}];
    ITC_struct_base.iERSP_category{i,1} = [group_name ' iERSP ' category_names{i}];
    ITC_struct_base.iITC_category{i,1} = [group_name ' iITC ' category_names{i}];
end


if ~exist(foldername,'dir');
    mkdir(foldername);
end

for j = 1:length(category_names)
    trial_index = EEG.category_names_count{j,3};
    for p = 1:nbchan
        for q = 1:length(trial_index) %ntrial for that condition
            idata = EEG.data(p,:,trial_index(q)) - mean(EEG.data(p,:,trial_index),3);
            EEG.idata(p,:,trial_index(q)) = idata;
        end
    end
end

    id = EEG.id;
    category_names_count = EEG.category_names_count;

    for j = 1:length(category_names)
        for p = 1:nbchan
%        for p = 1:2
            fprintf('\n\nprocessing %s, category %s, channal %s\n\n\n',id,category_names{j},channames{p});
            chan_list = p;
            

            trial_index = category_names_count{j,3};
            
            [ERSP,ITC,~,~,~]=newtimef(mean(EEG.data(chan_list,...
            datapoint_start:datapoint_end,trial_index),1), ...
            datapoint_end - datapoint_start + 1,calculation_time_range,...
            EEG.srate, [3, 0.5], 'nfreqs',n_freqs, 'freqs', freqs,...
            'timesout',n_times,'baseline',EEG.vbaseline,'plotitc','off',...
            'plotersp','off');

            ITC=abs(ITC);       
            ITC_z = r_to_z_4d(ITC);
            
            
            %20180508, induced
            [iERSP,iITC,~,~,~]=newtimef(mean(EEG.idata(chan_list,...
            datapoint_start:datapoint_end,trial_index),1), ...
            datapoint_end - datapoint_start + 1,calculation_time_range,...
            EEG.srate, [3, 0.5], 'nfreqs',n_freqs, 'freqs', freqs,...
            'timesout',n_times,'baseline',EEG.vbaseline,'plotitc','off',...
            'plotersp','off');

            iITC=abs(iITC);       
            iITC_z = r_to_z_4d(iITC);
            
            
            all_ERSP(:,:,j,p) = ERSP;
            all_ITC_z(:,:,j,p) = ITC_z;
            all_iERSP(:,:,j,p) = iERSP;
            all_iITC_z(:,:,j,p) = iITC_z;
        end
        

    end
    
    oscillation = ITC_struct_base;
    oscillation.id = id;
    oscillation.session = EEG.session;
    oscillation.ERSP = all_ERSP;
    oscillation.ITC = all_ITC_z;
    oscillation.iERSP = all_iERSP;
    oscillation.iITC = all_iITC_z;
   % save(['result/' id '_' EEG.session '_oscillation'], 'oscillation');
    save([foldername id '_oscillation'], 'oscillation');
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