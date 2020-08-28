%20171106, compose from all categories
%20171107, added oscillation_split, added the option of not removing
%filename and setname when they don't exist
%20171108, fixed a bug about oscillation_split
%20180413, added exclude_list, need more work to do the skip logic right
%20180424, finished the skip logic, used appropriate condition index and
%ids
function oscillation_multi = ITC_recompose_multi(data_path,...
    info_list,condition_index_of_interest,exclude_list)

if nargin == 3
    exclude_list = [];
end

m = 1;
id_count = 1;
id_list_new = cell(1);
condition_name_list = cell(1);

    for i = 1:length(info_list.id)
%    for i = 1:5
        id = info_list.id{i};
        
        %check whether id is excluded
        found_in_exclude_list = 0;
        for p = 1:length(exclude_list)
            cid = exclude_list{p};
            if strcmp(id,cid)==1
                found_in_exclude_list = 1;
                break
            end
        end
        if found_in_exclude_list == 1
            fprintf('%s found in exclude list, skip\n', id);
            continue;
        end
        %done checking
        
        
        %check whether the condition is included
        condition_index = info_list.condition_index(i);
        condition_name = info_list.condition_name{i};
        condition_index_in_dataset = find(condition_index_of_interest==condition_index,1);
        if isempty(condition_index_in_dataset)
            continue;
        end
        %done checking
        
        
        
        filename = info_list.filename{i};
        fprintf('loading %s......\n',filename);
        load([data_path filename]);
        if exist('oscillation_split','var')
            oscillation = oscillation_split;
        end
        
        if m==1
            id_list_new{id_count} = id;
        else
            if strcmp(id_list_new(id_count),id)~=1
                id_count= id_count+1;
                id_list_new{id_count} = id;
            end
        end
        
        %keep a running record to confirm at the end

        if m <= length(condition_index_of_interest)
            condition_name_list{m} = condition_name;

            current_condition_index = m;
        else
            current_condition_index = rem(m,length(condition_index_of_interest));
            if current_condition_index == 0
                current_condition_index =length(condition_index_of_interest);
            end
        end
        
        if m == 1
           oscillation_multi = oscillation;
           oscillation_multi = rmfield(oscillation_multi,'id');
           
           if isfield(oscillation_multi,'filename');
               oscillation_multi = rmfield(oscillation_multi,'filename');
           end
           if isfield(oscillation_multi,'setname');
               oscillation_multi = rmfield(oscillation_multi,'setname');
           end
        end
        
        %add the oscillation data to the structure
        oscillation_multi.ERSP(:,:,:,current_condition_index,id_count) = oscillation.ERSP;
        oscillation_multi.ITC(:,:,:,current_condition_index,id_count) = oscillation.ITC;
        
        running_record.id{m} = id;
        running_record.condition_index(m) = condition_index;
        running_record.condition_name{m} = condition_name;
        running_record.current_condition_index(m) = current_condition_index;
        
        
        m = m + 1;

    end
    oscillation_multi.id = id_list_new;
    oscillation_multi.category_names = condition_name_list;
    oscillation_multi.running_record = running_record;

end