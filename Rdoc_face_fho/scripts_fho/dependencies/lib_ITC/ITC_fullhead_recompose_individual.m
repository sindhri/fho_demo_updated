%20160211, renamed foi_type to oscillation_type
%20170619, grab only the foi from each file, such as [4,8];
%instead of loading the whole dataset

%result foi_struct.data, ntimes x ncond x nchan x nsubj
%calculate for both ERSP and ITC
%20180713, added optional group name, usually group_name was brought in
%while calculating ERSP/ITC, but it could be brought in later too.


function foi_struct = ITC_fullhead_recompose_individual(foi,pathname,group_name)

if nargin==1
    pathname = uigetdir(pwd,'select oscillation result folder');
end

if nargin==1 || nargin==2
    group_name = '';
end

file_list = dir(pathname);

id_lsit = cell(1);
session_list = cell(1);

   m = 0; 
for i = 1:length(file_list)
    temp = file_list(i).name;
    if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.mat')
        
        m = m+1;
        filename = temp;
            
        [id,session] = parse_filename(filename);
        id_list{m} = id;
        session_list{m} = session;
            
        load([pathname '/' filename]);
        fprintf('loading %s\n',filename);
        
        if m == 1
            foi_index = find_valid_pos(foi,oscillation.freqs);
            f1 = oscillation.freqs(foi_index(1));
            f2 = oscillation.freqs(foi_index(2));
            name_for_plot = [num2str(f1), 'to' num2str(f2), 'Hz'];
            fprintf('frequency of interest is adjusted to:\n%s\n', name_for_plot);    
            name_for_column = [dot2p(num2str(f1)) '_' dot2p(num2str(f2)), 'Hz'];
    
            foi_struct.foi = [f1,f2];
            foi_struct.name_for_plot = name_for_plot;
            foi_struct.name_for_column = name_for_column;
            foi_struct.category_names = oscillation.category_names;
        end
        
        foi_data_ERSP = get_one_freq(oscillation,foi,'ERSP');
        foi_data_ITC = get_one_freq(oscillation,foi,'ITC');
        
        if m == 1
            foi_data_all_ERSP = foi_data_ERSP;
            foi_data_all_ITC = foi_data_ITC;
        else
            foi_data_all_ERSP(:,:,:,m) = foi_data_ERSP;
            foi_data_all_ITC(:,:,:,m) = foi_data_ITC;
        end
        
    end
end

foi_struct.ERSP = foi_data_all_ERSP;
foi_struct.ITC = foi_data_all_ITC;

if ~isempty(oscillation.group_name)
    foi_struct.group_name = oscillation.group_name;
else
    foi_struct.group_name = group_name;
end
foi_struct.freqs = foi;
foi_struct.times = oscillation.times;
foi_struct.ntimes = oscillation.ntimes;
foi_struct.channames = oscillation.channames;
foi_struct.nbchan = oscillation.nbchan;

foi_struct.id = id_list;
foi_struct.session = session_list;
fprintf('recompose complete.\n');
end

function [id,session] = parse_filename(filename)
    underscore = find(filename=='_');
    id = filename(1:underscore(1)-1);
    if length(underscore)<2
        session = 1;
    else
        session= filename(underscore(1)+1:underscore(2)-1);
        session = str2double(session);
        if isNAN(session)
            session = 1;
        end
    end
end

function foi_data = get_one_freq(oscillation,foi,oscillation_type)
    foi_index = find_valid_pos(foi,oscillation.freqs);
    [~,nt,nc,nch] = size(oscillation.ERSP);

    if strcmp(oscillation_type,'ERSP')
        temp = mean(oscillation.ERSP(foi_index(1):foi_index(2),:,:,:),1);
    elseif strcmp(oscillation_type,'ITC')
        temp = mean(oscillation.ITC(foi_index(1):foi_index(2),:,:,:),1);
    else
        fprintf('type must be either ERSP or ITC\n');
    end
    
    foi_data = reshape(temp(1,:,:,:),[nt,nc,nch]); %foi.data: times * nc* chan
end

%find the index of items on a evenly distributed continous list, and the adjusted item
%such as, find when times==0ms in a list of [-100,10,100];
function [items_pos, items_adjusted] = find_valid_pos(items,list)
    n = length(list);
    items_pos = round( (items-list(1))/(list(n)-list(1)) * (n-1))+1;
    items_pos(find(items_pos<1))=1;
    items_pos(find(items_pos>n))=n;
    items_adjusted = list(items_pos);
end

function newstring = dot2p(astring)
    newstring = astring;
    for i = 1:length(astring)
        if astring(i)== '.';
            newstring(i) = 'p';
        end
    end
end

