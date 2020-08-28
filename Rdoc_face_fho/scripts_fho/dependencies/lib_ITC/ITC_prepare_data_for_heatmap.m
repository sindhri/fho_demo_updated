%20141202, get the mean of one frequency from the IE for later full head plotting
%output dimension: IE.foi.data = times x ncond x nsubj x nchan
%trick the topoplot with ALLEEG structure, even though it is not EEG.
%ALLEEG(ncond).data dimension: nchan x ntime x nsubj
%20150309, added net_type, 1 for hydrocel, 2 for GSN 129
%20150512, added to select just 2 conditions

function ALLEEG = ITC_prepare_data_for_heatmap(IE,foi,foi_type,net_type,...
    selected_conditions)

if nargin==4
    selected_conditions = [1,2];
end

IE = get_2_condition(IE,selected_conditions);

foi_struct = get_one_freq_for_heatmap(IE,foi,foi_type);
data = foi_struct.data;
[ntime,ncond,nsubj,nchan] = size(data);
for m = 1:ncond
    new_data = zeros(nchan,ntime,nsubj);
    for i = 1:nchan
        for j = 1:ntime
            for p = 1:nsubj
                new_data(i,j,p) = data(j,m,p,i);
            end
        end
    end

    EEG.data = new_data;
    EEG.data_avg = mean(new_data,3);
    if net_type == 1
        EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Hydrocell_Chan129.loc';
    else
        EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Chan129.loc';
    end
    EEG.xmin = IE.times(1)/1000;
    EEG.xmax = IE.times(length(IE.times))/1000;
    EEG.nbchan = nchan;
    if ~isempty(IE.group_name)
        EEG.setname = strcat(IE.group_name, '_', IE.category_names{m},'_',foi_type,'_',foi_struct.name_for_plot);
    else
        EEG.setname = strcat(IE.category_names{m},'_',foi_type,'_',foi_struct.name_for_plot);
    end
    EEG.pnts = ntime;
    EEG.trials = nsubj;
    EEG.times = IE.times;
    EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];
    EEG.mean = mean(EEG.data_avg(:));
    EEG.std = std(EEG.data_avg(:));
    
    EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
    EEG.limit = [-EEG.abs,EEG.abs];
    ALLEEG(m) = EEG;
end

if ncond==2
    EEG.data = ALLEEG(1).data-ALLEEG(2).data;
    EEG.data_avg = mean(EEG.data,3);
    EEG.mean = mean(EEG.data_avg(:));
    EEG.std = std(EEG.data_avg(:));
    EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
    EEG.limit = [-EEG.abs,EEG.abs];
    if ~isempty(IE.group_name)
        EEG.setname = strcat(IE.group_name, '_', 'diff(',...
            IE.category_names{1}, '-', IE.category_names{2},')' ,foi_type,'_',foi_struct.name_for_plot);
    else
        EEG.setname = strcat('diff',IE.category_names{1}, '-', ...
            IE.category_names{2},')' ,foi_type,'_',foi_struct.name_for_plot);
    end
    
    EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];
    ALLEEG(3) = EEG;
end
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

    if strcmp(foi_type,'ERSP')
        foi_struct.data = squeeze(mean(IE.ERSP(foi_index(1):foi_index(2),:,:,:,:),1)); %data: times * nc *ns * chan
    elseif strcmp(foi_type,'ITC')
        foi_struct.data = squeeze(mean(IE.ITC(foi_index(1):foi_index(2),:,:,:,:),1)); %data: times * nc *ns * chan
    else
        fprintf('type must be either ERSP or ITC\n');
    end
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

%get the specific 2 condition from multiple. need to split all the fields
function IE2 = get_2_condition(IE,selected_conditions)

if length(IE.category_names)==2 && selected_conditions(1)==1 && selected_conditions(2)==2
    IE2 = IE;
    return
end

if length(selected_conditions) ~=2
    fprintf('can only pick 2 conditions! Abort.\n')
    return
end

if length(IE.category_names)<2
    fprintf('input needs to have at least 2 conditions! Abort.\n');
    return
end

IE2 = IE;
for i = 1:length(selected_conditions)
    IE2.category_names{i} = IE.category_names{selected_conditions(i)};
    IE2.ERSP_category{i} = IE.ERSP_category{selected_conditions(i)};
    IE2.ITC_category{i} = IE.ITC_category{selected_conditions(i)};
end


IE2.ERSP = IE.ERSP(:,:,selected_conditions,:,:);
IE2.ERSP_mean = mean(IE2.ERSP,4);
IE2.ITC = IE.ITC(:,:,selected_conditions,:,:);
IE2.ITC_mean = mean(IE2.ITC,4);
end