%input IE.data freq x time x cond x subj x chan
%output data, specify freq, chan x time x cond x subj
%also removed baseline for pca
function foi_struct = ITC_prepare_fullhead_data_for_stPCA(IE, foi, foi_type)
    foi_struct = get_one_freq_for_heatmap(IE,foi,foi_type);
    foi_struct.data_stpca = change_dimension(foi_struct.data);
    foi_struct.data_stpca = foi_struct.data_stpca(:,IE.times>=0,:,:);
    foi_struct.times = IE.times(IE.times>=0);
end

function foi_struct = get_one_freq_for_heatmap(IE,foi,foi_type)
    foi_index = find_valid_pos(foi,IE.freqs);

    f1 = IE.freqs(foi_index(1));
    f2 = IE.freqs(foi_index(2));

    name_for_plot = [num2str(f1), ' to ' num2str(f2), ' Hz'];
    fprintf('frequency of interest is adjusted to:\n%s\n', name_for_plot);
    
    name_for_column = [dot2p(num2str(f1)) '_' dot2p(num2str(f2)), 'Hz'];
    
    foi_struct.type = foi_type;
    foi_struct.foi = [f1,f2];
    foi_struct.name_for_plot = name_for_plot;
    foi_struct.name_for_column = name_for_column;
    foi_struct.category_names = IE.category_names;
    foi_struct.id = IE.id;

    if strcmp(foi_type,'ERSP')
        foi_struct.data = squeeze(mean(IE.ERSP(foi_index(1):foi_index(2),:,:,:,:),1)); %data: times * nc *ns * chan
    elseif strcmp(foi_type,'ITC')
        foi_struct.data = squeeze(mean(IE.ITC(foi_index(1):foi_index(2),:,:,:,:),1)); %data: times * nc *ns * chan
    else
        fprintf('type must be either ERSP or ITC\n');
    end
end

function [items_pos, items_adjusted] = find_valid_pos(items,list)
    n = length(list);
    items_pos = round( (items-list(1))/(list(n)-list(1)) * (n-1))+1;
    items_pos(find(items_pos<1))=1;
    items_pos(find(items_pos>n))=n;
    items_adjusted = list(items_pos);
end

%input time x cond x subj x chan
%output chan x time x cond x subj
function data_new = change_dimension(data)
[ntime, ncond, nsubj, nchan] = size(data);
data_new = zeros(nchan, ntime, ncond, nsubj);
for a = 1:nchan
    data_new(a,:,:,:) = data(:,:,:,a);
end
end

function newstring = dot2p(astring)
    newstring = astring;
    for i = 1:length(astring)
        if astring(i)== '.';
            newstring(i) = 'p';
        end
    end
end

