%2-171106, working with only one condition, compose from the whole
%directory

function oscillation_one = ITC_recompose_one(data_path,...
    info_list,id_list,condition_index)

    m = 1;
    for i = 1:length(id_list);
        id = id_list{i};
        for j = 1:length(info_list.id)
            if strcmp(info_list.id{j},id)==1 && info_list.condition_index(j) == condition_index
                filename= info_list.filename{j};
                break
            end
        end
        load([data_path filename]);
        fprintf('loading %s......\n',filename);
        if m == 1
            oscillation_one = oscillation;
            rmfield(oscillation_one,'id');
            oscillation_one.id = id_list;
            oscillation_one.condition_index = condition_index;
            oscillation_one.condition_name = info_list.condition_name{j};
            rmfield(oscillation_one,'filename');
        else
            oscillation_one.ERSP(:,:,:,m) = oscillation.ERSP;
            oscillation_one.ITC(:,:,:,m) = oscillation.ITC;
        end
        m = m +1;
   
    end
    
    fprintf('found %d files\n',m-1);
end