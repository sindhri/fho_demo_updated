
%need to think about how to get id from filename for other projects
%20130718, updated find_id to be, first number till last number
%20130625, added noncell condition for EEG.epoch(1).eventcategory
%20130318, renamed, found out it doesn't work for ave data.
%20130226, added baseline, in terms of miliseconds, because this
%information is unavailable in raw format
%baseline defined as the period before time 0, not for calculation purpose
%20130221, tried to group trials based on categoryname
%20130131, added file name validation

%20141009, read set and modified trial output, 
%in the trial count, excluded the rejected trial
%in the trial list for each category, omitted the rejected trial, 
%the trial order stays  original order.
%outcome: EEG has all the trials, trial count removed the rejected trials
%trial list keeps the original position of the trial

function alleeg = ITC_read_set(category_names)
    [~,pathname] = uigetfile('*.set',pwd);
    file_list = dir(pathname);
%    category_names = {'go_correct','nogo_correct'};

    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.set')
            filename = temp;
            EEG = pop_loadset([pathname filename]);
            id = EEG.subject;
            EEG.id = id;
            id_list{m} = id;
            fprintf('%s\n',id);
            [category_names_count,simple_count,EEG] = EEG_list_trials2(EEG,category_names);

            EEG.category_names_count = category_names_count;
            EEG.baseline = abs(EEG.times(1));
            EEG.category_names = category_names;
            alleeg(m) = EEG;
            m = m+1;
            trial_count = [trial_count;simple_count];
        end
    end
    export_trial_count(pathname,trial_count,category_names,id_list);
    msgbox('trial count saved in ''trial_count.txt''.');
end


%EEG after using ITC_read_set
%list the trial numbers for each member in category_names
%also modify EEG remove rejected trials
function [category_names_counts,simple_count,EEG] = EEG_list_trials2(EEG,category_names)
    n_category = length(category_names);
    n_trials = EEG.trials;
    category_names_counts = cell(n_category,3);
    
    for i = 1:n_category
        category_names_counts{i,1} = category_names{i};
    end
    
    for j = 1:n_category
        category_names_counts{j,2} = 0;
        category_names_counts{j,3} = [];
    end
    for j = 1:n_trials
        if EEG.reject.rejthresh(j) == 1 %rejected trial
            continue
        end
        if iscell(EEG.epoch(j).eventtype)
            category = EEG.epoch(j).eventtype{1};
        else
            category = EEG.epoch(j).eventtype;
        end
        
        for p = 1:n_category
            if strcmp(category_names{p},category)==1       
                category_names_counts{p,2} = category_names_counts{p,2} + 1;
                category_names_counts{p,3} = [category_names_counts{p,3}, j];
                break
            end
        end
    end
    simple_count = zeros(1,n_category);
    for i = 1:n_category
        simple_count(1,i) = category_names_counts{i,2};
    end
end

function export_trial_count(pathname,trial_count,category_names,id_list)
    A = dataset({trial_count,category_names{:}},'ObsNames',id_list);
    export(A,'file',[pathname 'trial_count.txt']);
end