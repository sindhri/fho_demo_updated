%20200825, switch to the global find_id, insteaad of the internal function
%1, first number
%2, anything until the first dot
%3, TS id is either H with a number, or everything before the second dot.
%4, anything before the second '_'
%5, first and second number combined as id, leigh data

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
%20170608, added variable baseline based on stefon's analysis
%so the whole pre-stimulus duration is 1.5s, but the baseline for 
%oscillation is only -600 to -100 ms.
%added input vbaseline, [-600,-100]
%20170612, found out there might be a length limitation of the path
%otherwise it doesn't find any files.
%also modified to look for path of raw files uigetdir instead of raw files
%uigetfile
%20170612 added testmode only calculate one subject one condition
%20170615, change it to only calculate one subject
%20180412, added downsampling ability to make bomb data compatible

function ITC_single_file_vbaseline_one_subject(category_names,baseline,...
    vbaseline,group_name,id_type,freqs,...
    pathname,result_foldername,testmode, subject_ID,target_rate)

    file_list = dir(pathname);

    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.raw')
            filename = temp;
            
            [id,session] = find_id(id_type,filename);
            
            if strcmp(id,subject_ID)==1
        
                [EEG,~] = get_EEG_vbaseline(pathname,filename,...
                    category_names,baseline,vbaseline,group_name,id_type);
                
                if nargin==10
                    target_rate = EEG.srate;
                else
                    EEG = ITC_downsampling_EEG(EEG,target_rate); %added downsampling ability
                end
                
                ITC_calculation_single_file_vbaseline(EEG,freqs,...
                result_foldername,testmode);
                m = m+1;
            end
              
            if testmode == 'y'
               if m == 2
                    break
               end
            end
        end
    end
    
    %export_trial_count(pathname,trial_count,category_names,id_list);
    %msgbox('trial count saved in ''trial_count.txt''.');
end

%20200825, switch to global find_id
function [EEG,simple_count] = get_EEG_vbaseline(pathname,filename,...
    category_names,baseline,vbaseline,group_name,id_type)
         [id,session] = find_id(id_type, filename);
            
            fprintf('%s\n',id);
            EEG = pop_readegi([pathname filename]);
            [category_names_count,simple_count] = EEG_list_trials(EEG,category_names);
            EEG.id = id;
            EEG.session = session;
            EEG.category_names_count = category_names_count;
            EEG.baseline = baseline;
            EEG.vbaseline = vbaseline;
            EEG.category_names = category_names;
            EEG.xmin = EEG.xmin - baseline/1000;
            EEG.xmax = EEG.xmax - baseline/1000;
            EEG.times = EEG.times - baseline;
            EEG.group_name = group_name;            
end


%find_id series, removed 20200825
%id is the first number in the file string
%Works for general purpose projects with single visit, 
%and use only number (instead of letters) as ID

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
