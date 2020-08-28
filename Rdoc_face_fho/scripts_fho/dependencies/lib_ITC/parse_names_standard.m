%first 4 digit id
%underscore
%rest condition name
%.mat
function [info_list,id_list] = parse_names_standard(data_path,category_names)

file_list = dir(data_path);
m = 1;
for i = 1:length(file_list)
    filename = file_list(i).name;
    if filename(1) =='.';
        continue
    end
    
    
    id = find_id(filename);
    [condition_name,condition_index] = find_condition_name(filename,...
        category_names);
    info_list.id{m,1} = id;
    info_list.condition_index(m,1) = condition_index;
    info_list.condition_name{m,1} = condition_name;
    info_list.filename{m,1} = filename;
    if length(id)~=4
        fprintf('error at %s, id reported as %s\n',filename,id);
    end
    if isempty(condition_index)
        fprintf('error at %s,condition reported as %s\n',filename,condition_name);
    end
    m = m + 1;
end

id_list = unique(info_list.id);

end

%rmoved i from number
function id = find_id(filename)
    first = [];
    last = [];
    for i = 1:length(filename)
        current = filename(i);
        if current == 'i';
            continue;
        end
        if ~isempty(str2num(current)) && isempty(first)
            first = i;
            break
        end
    end
    for i = first+1:length(filename)
            current = filename(i);
        if isempty(str2num(current)) && isempty(last)
            last = i-1;
            break
        end
    end
    id = filename(first:last);
end

function [condition_name,condition_index] = find_condition_name(filename,...
    category_names)
    nfilename = length(filename);
    underscores = find(filename=='_');
    condition_index = [];
    condition_name = filename(underscores(1)+1:nfilename-4);
    for i = 1:length(category_names)
        if strcmp(category_names{i},condition_name)==1
            condition_index = i;
            break
        end
    end
end
