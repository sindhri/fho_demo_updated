function ITC_count_trials_mat(category_names,id_type,pathname)

    if nargin==2
        pathname = uigetdir(pwd,'select mat file folder');
        pathname = [pathname '/'];
    end

    fprintf('pathname is %s\n', pathname);
    file_list = dir(pathname);
    trial_count = [];
    id_list = cell(1);
    m = 1;
    for i = 1:length(file_list)
        temp = file_list(i).name;
        if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.mat')
        filename = temp;
            if id_type==1
                id = find_id(filename);
            elseif id_type==2
                id = find_id2(filename);
            else
                 id = find_id3(filename);
            end
            id_list{m} = id;
            fprintf('%s\n',id);       
            for j = 1:length(category_names)
                load([pathname filename],category_names{j});
                trial_count(m,j) = size(eval(category_names{j}),3);
            end
            m = m + 1;
    
        end
    end
    export_trial_count(pathname,trial_count,category_names,id_list);
    msgbox('trial count saved in ''trial_count.txt''.');
end
        %find the first number in the filename and use it as the id
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

function id=find_id2(filename)
    dots = find(filename=='.');
    id = filename(1:dots(1)-1);
end

function id = find_id3(filename)
    dots = find(filename=='.');
    if filename(3) ~= 'H'
        id = find_id(filename(1:dots(1)));
        session = filename(dots(1)+1:dots(2)-1);       
    else
        id = find_id(filename);
        id = ['H' id];
        session = '1';
    end
    id = [id '_' session];
end
function export_trial_count(pathname,trial_count,category_names,id_list)
    A = dataset({trial_count,category_names{:}},'ObsNames',id_list);
    export(A,'file',[pathname 'trial_count.txt']);
end
