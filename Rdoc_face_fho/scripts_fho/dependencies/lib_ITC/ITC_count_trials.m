
%need to think about how to get id from filename for other projects
%20130718, updated find_id to be, first number till last number
%20130625, added noncell condition for EEG.epoch(1).eventcategory
%20130318, renamed, found out it doesn't work for ave data.
%20130226, added baseline, in terms of miliseconds, because this
%information is unavailable in raw format
%baseline defined as the period before time 0, not for calculation purpose
%20130221, tried to group trials based on categoryname
%20130131, added file name validation
%20141106, added category_names in EEG
%20150917, added id_type for autism id style, 7392_04, use first .
%id_type=1, use the first number
%id_type=2, use everything till the first dot. 

%20151214, modified it to count trials from raw file from blc
%20160901, added TS case, use up to second . as the id. id_type=3;
%unless it is healthy control. which doesn't have the second .
%20170612, added pathname
%20180413, use the shared find_id,
%20180602, switched the order of feeding in ITC_find_id


function ITC_count_trials(category_names,id_type,pathname)
    
if nargin==2
    pathname = uigetdir(pwd,'select raw file folder');
    pathname = [pathname '/'];
end

    fprintf('pathname is %s\n', pathname);
    file_list = dir(pathname);


    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.raw')
            filename = temp;
            id = ITC_find_id(id_type,filename);
            id_list{m} = id;
            fprintf('%s\n',id);
            EEG = pop_readegi([pathname filename]);
            [~,simple_count] = EEG_list_trials(EEG,category_names);
            m = m+1;
            trial_count = [trial_count;simple_count];
        end
    end
    export_trial_count(pathname,trial_count,category_names,id_list);
    msgbox('trial count saved in ''trial_count.txt''.');
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