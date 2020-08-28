%20160211, renamed foi_type to oscillation_type
%added explicit pathname
%20180316, if group_name doesn't exist, use ''

function IE = ITC_fullhead_recompose(oscillation_type,pathname)
if nargin==1
    pathname = uigetdir(pwd,'select oscillation result folder');
end
file_list = dir(pathname);
m = 0;
data_all = [];
id_lsit = cell(1);
session_list = cell(1);
for i = 1:length(file_list)
    temp = file_list(i).name;
    if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.mat')
        m = m+1;
        filename = temp;
            
        [id,session] = parse_filename(filename);
        id_list{m} = id;
        session_list{m} = session;
        fprintf('loading %s\n',filename);    
        load([pathname '/' filename]);
        
        data = oscillation.(oscillation_type);
            
        if m == 1
            data_all = data;
        else
            data_all(:,:,:,:,m) = data;
        end
    end
end

IE.(oscillation_type) = data_all;
IE.oscillation_type = oscillation_type;
if isfield(oscillation,'group_name')
    IE.group_name = oscillation.group_name;
else
    IE.group_name = '';
end
IE.freqs = oscillation.freqs;
IE.times = oscillation.times;
IE.ntimes = oscillation.ntimes;
IE.channames = oscillation.channames;
IE.nbchan = oscillation.nbchan;
IE.category_names = oscillation.category_names;
IE.id = id_list;
IE.session = session_list;
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