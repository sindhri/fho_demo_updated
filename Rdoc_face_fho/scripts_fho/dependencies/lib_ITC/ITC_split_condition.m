%the original way of doing things takes too much memory
%split into conditions, then recompose them

function ITC_split_condition(data_path,split_path)

file_list = dir(data_path);

if ~exist(split_path)
    mkdir(split_path);
end

for i = 1:length(file_list)
    fname = file_list(i).name;
    if fname(1)=='.'
        continue;
    end
    id = find_id(fname);
    fprintf('loading %s\n',fname);
    load([data_path fname]);

    ncond = length(oscillation.category_names);
    for j = 1:ncond
        oscillation_split=oscillation;
        oscillation_split.category_name = oscillation.category_names{j};
        oscillation_split.ERSP = squeeze(oscillation.ERSP(:,:,j,:));
        oscillation_split.ITC = squeeze(oscillation.ITC(:,:,j,:));
        fname_split = [split_path id '_' oscillation_split.category_name '.mat'];
        fprintf('saving %s, %s\n',id,oscillation_split.category_name);
        save(fname_split, 'oscillation_split','-mat');        
    end

end
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