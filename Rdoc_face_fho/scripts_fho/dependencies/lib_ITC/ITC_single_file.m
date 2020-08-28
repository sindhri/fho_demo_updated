%20151104, work on single EEG structur
%operates on each file in one folder
%20151104
%read the raw file, calculate ERSP and ITC for fullhead and generate a structure. 
%then save the IE struction under the ID name
%id_type=1, first number as id
%id_type=2, everything before the first . as id
%id_type=3, TS specific, two types, Hxxx uses id_type=1, otherwise
%everything till the second dot(.).
%20160428, added find_id4 for language study IDs
%20160608, added input and output foldernames

function ITC_single_file(category_names,baseline,group_name,id_type,freqs,...
    pathname,foldername)

    if nargin==5
        [~,pathname] = uigetfile('*.raw',pwd);
        
        foldername = [pwd '/result/'];
    end

    file_list = dir(pathname);

    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.raw')
            filename = temp;
            
            [EEG,simple_count] = get_EEG(pathname,filename,category_names,baseline,group_name,id_type);
            id_list{m} = EEG.id;
            trial_count = [trial_count; simple_count];
            ITC_calculation_single_file(EEG,freqs,foldername);
            m = m+1;
 %           if m == 2
 %               break
 %           end
        end
    end
    
    export_trial_count(pathname,trial_count,category_names,id_list);
    msgbox('trial count saved in ''trial_count.txt''.');
end

function [EEG,simple_count] = get_EEG(pathname,filename,category_names,baseline,group_name,id_type)
            switch id_type
                case 1
                    [id,session] = find_id(filename);
                case 2
                    [id,session] = find_id2(filename);
                case 3
                    [id,session] = find_id_TS(filename);
                case 4
                    [id,session] = find_id4(filename);
            end
            
            fprintf('%s\n',id);
            EEG = pop_readegi([pathname filename]);
            [category_names_count,simple_count] = EEG_list_trials(EEG,category_names);
            EEG.id = id;
            EEG.session = session;
            EEG.category_names_count = category_names_count;
            EEG.baseline = baseline;
            EEG.category_names = category_names;
            EEG.xmin = EEG.xmin - baseline/1000;
            EEG.xmax = EEG.xmax - baseline/1000;
            EEG.times = EEG.times - baseline;
            EEG.group_name = group_name;            
end


%id is the first number in the file string
%Works for general purpose projects with single visit, 
%and use only number (instead of letters) as ID
function [id,session] = find_id(filename) 
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
    session = '1';
end

%id is the digits before the first dot(.), 
%Works for TRP after replacing . with _
function [id,session]=find_id2(filename)
    dots = find(filename=='.');
    id = filename(1:dots(1)-1);
    session = '1';
end

function [id,session]=find_id4(filename)
    underscores = find(filename=='_');
    id = filename(1:underscores(1)-2);
    session = '1';
end

%id is either H with a number, or everything before the second dot.
function [id,session]=find_id_TS(filename)
    if filename(3)=='H'
        id = find_id(filename);
        id = strcat('RDH',id);
        session = '1';
    else
        dots = find(filename=='.');
        id = filename(1:dots(1)-1);
        session = filename(dots(1)+1:dots(2)-1);
    end
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
