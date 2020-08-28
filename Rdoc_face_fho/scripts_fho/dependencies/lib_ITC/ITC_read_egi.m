
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
%20150917, added id_type for autism id style, 7392_04, use everything till the first dot .
%id_type=1, use the first number
%id_type=2, use everything till the first dot. 
%20160317, added net_type, 1 as hydrocel, 2 as GSN129
%20160905, added id_type 3, for TS rDOc, id and session becomes id_session
%20170920, used uigetdir to replace uigetfile. added hard coded pathname
%option
%seems to have some issues of whether to use the 129 channel fileloc or 132
%in this version, had to use the 132 version in order to get ther 129
%structure

%20171129, fixed a very big bug, that wasn't affecting much previous data
%but affecting data that was merged from different preprocessing
%sorted the data based on the actual category_names sequence, not a blind
%one, need to go back and double check previous data, only affecting
%reading ave data, because for blc we actually send the real index into
%calculation
%added input type = 'ave' for ave file
%20180502, used external function ITC_find_id, removed exporting trial
%number for ave files becase it's all 1
function alleeg = ITC_read_egi(category_names,baseline,group_name,id_type,...
    net_type,pathname,type)

    if nargin == 5
        pathname = uigetdir(pwd);
        pathname = [pathname '/'];
        type = '';
    end
    file_list = dir(pathname);
    
    if net_type==1
        fileloc = 'GSN-HydroCel-129plus3.sfp';
    else
        fileloc = 'GSN129.sfp';
    end
    
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

            EEG = pop_readegi([pathname filename],[],[],fileloc);
            [category_names_count,simple_count,sorted_index] = EEG_list_trials(EEG,category_names);
            EEG.id = id;
            if strcmp(type,'ave')==1
                EEG.data = EEG.data(:,:,sorted_index);
            end        
            EEG.category_names_count = category_names_count;
            EEG.baseline = baseline;
            EEG.category_names = category_names;
            EEG.xmin = EEG.xmin - baseline/1000;
            EEG.xmax = EEG.xmax - baseline/1000;
            EEG.times = EEG.times - baseline;
            EEG.group_name = group_name;
            alleeg(m) = EEG;
            m = m+1;
            trial_count = [trial_count;simple_count];
        end
    end
    if strcmp(type,'ave')~=1
        export_trial_count(pathname,trial_count,category_names,id_list);
        msgbox('trial count saved in ''trial_count.txt''.');
    end
end

%EEG after using read_egi
%list the trial numbers for each member in category_names
function [category_names_counts,simple_count,sorted_index] = EEG_list_trials(EEG,category_names)
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
    sorted_index = [];
    for j = 1:n_trials
        if iscell(EEG.epoch(j).eventcategory)
            category = EEG.epoch(j).eventcategory{1};
        else
            category = EEG.epoch(j).eventcategory;
        end
        
        for p = 1:n_category
            if strcmp(category_names{p},category)==1
                sorted_index(p) = j;
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