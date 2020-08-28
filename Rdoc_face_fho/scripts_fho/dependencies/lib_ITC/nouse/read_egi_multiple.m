
%20130226, added baseline, in terms of miliseconds, because this
%information is unavailable in raw format
%baseline defined as the period before time 0, not for calculation purpose
%20130221, tried to group trials based on categoryname
%20130131, added file name validation
%20140130, updated find_id from read_egi_singletrial_multiplefiles

function alleeg = read_egi_multiple(category_names,baseline)
    [~,pathname] = uigetfile('*.raw',pwd);
    file_list = dir(pathname);
%    category_names = {'go_correct','nogo_correct'};

    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.raw')
            filename = temp;
            id = find_id(filename);
            id_list{m} = id;
            fprintf('%s\n',id);
            EEG = pop_readegi([pathname filename]);
            [category_names_count,simple_count] = EEG_list_trials(EEG,category_names);
            EEG.id = id;
            EEG.category_names_count = category_names_count;
            EEG.baseline = baseline;
            EEG.xmin = EEG.xmin - baseline/1000;
            EEG.xmax = EEG.xmax - baseline/1000;
            EEG.times = EEG.times - baseline;
            alleeg(m) = EEG;
            m = m+1;
            trial_count = [trial_count;simple_count];
        end
    end
    export_trial_count(pathname,trial_count,category_names,id_list);
    msgbox('trial count saved in ''trial_count.txt''.');
end

function id = find_id(filename)
    first = [];
    last = [];
    for i = 1:length(filename)
        if ~isempty(str2num(filename(i))) && isempty(first)
            first = i;
            break
        end
    end
    for i = first+1:length(filename)
        if isempty(str2num(filename(i))) && isempty(last)
            last = i-1;
            break
        end
    end
    id = filename(first:last);
end


%EEG after using read_egi
%list the trial numbers for each member in category_names
function [category_names_counts,simple_count] = EEG_list_trials(EEG,category_names)
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
        category = EEG.epoch(j).eventcategory{1};

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