%convert .raw file with multiple conditions to multiple .set files
%baseline is in ms;
%20180412, stripped out id identification to external program
%added condition_index, and condition_name, removed message box

function trial_count = raw_to_set_multiple(category_names,baseline,id_type)
    [~,pathname] = uigetfile('*.raw',pwd);
    pathname_set = strrep(pathname,'raw','set');
    mkdir(pathname_set);
    file_list = dir(pathname);
    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        fnl = length(temp);
        if strcmp(temp(1),'.')~=1 && strcmp(temp(fnl-3:fnl),'.raw')
            filename = temp;
  
            id = ITC_find_id(filename,id_type);
            
            id_list{m} = id;
            fprintf('%s\n',id);
            EEG = pop_readegi([pathname filename]);
            EEG.baseline = baseline;
            EEG.xmin = EEG.xmin - baseline/1000;
            EEG.xmax = EEG.xmax - baseline/1000;
            EEG.times = EEG.times - baseline;
            [category_names_count,simple_count] = EEG_list_trials(EEG,category_names);
            for j = 1:length(category_names)
               
                EEG_single_condition = EEG;
                EEG_single_condition.condition_name = category_names{j};
                EEG_single_condition.condition_index = j;
                EEG_single_condition = rmfield(EEG_single_condition,'epoch');
                ntrials = category_names_count{j,2};
                trial_list = category_names_count{j,3};
                EEG_single_condition.trials = ntrials;
                EEG_single_condition.data = EEG.data(:,:,trial_list);
                for p = 1:ntrials
                    EEG_single_condition.epoch(p) = EEG.epoch(trial_list(p));
                end
%                EEG_single_condition = rmfield(EEG_single_condition,'event');
%                EEG_single_condition = rmfield(EEG_single_condition,'urevent');
%                EEG_single_condition = rmfield(EEG_single_condition,'eventdescription');
                 output_filename = [id '_' category_names{j}];
                 output_pathname = pathname_set;
                pop_saveset(EEG_single_condition,'filepath',output_pathname,'filename',output_filename);
            end
            m = m+1;
            trial_count = [trial_count;simple_count];
        end

    end
    export_trial_count(pathname,trial_count,category_names,id_list);
%    msgbox('trial count saved in ''trial_count.txt''.');
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
        if iscell(EEG.epoch(j).eventcategory)
            category = EEG.epoch(j).eventcategory{1};
        else
            category = EEG.epoch(j).eventcategory;
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
