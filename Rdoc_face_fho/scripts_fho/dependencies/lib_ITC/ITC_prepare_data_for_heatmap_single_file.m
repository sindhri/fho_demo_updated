%20141202, get the mean of one frequency from the IE for later full head plotting
%output dimension: IE.foi.data = times x ncond x nsubj x nchan
%trick the topoplot with ALLEEG structure, even though it is not EEG.
%ALLEEG(ncond).data dimension: nchan x ntime x nsubj
%20150309, added net_type, 1 for hydrocel, 2 for GSN 129
%20150512, added to select just 2 conditions

%2051105, grab single file from saved .mat files
%20151213, added ( when there is no group name for the difference wave
%20151215, added IE as the variable, recomposed from another function
%it only has either ERSP or ITC
%20151215, changed ITC scale to be 0 to EEG.abs.
%20160211, renamed foi_type to oscillation_type, removed oscillation_type
%because the input IE struct only has one type, either ITC or ERSP
%20160317, changed the location files to be default eeglab ones....did not
%test it yet
%20160702, added selected_condition, otherwise it defaults to be the first
%20180514, enable usage of flexible oscillation_type, so can use iERSP, and
%iITC


function ALLEEG = ITC_prepare_data_for_heatmap_single_file(IE, foi,net_type,...
    selected_conditions)
if nargin==3
    selected_conditions = [1,2];
end

IE = get_2_conditions(IE,selected_conditions);
oscillation_type = IE.oscillation_type;
foi_struct = get_one_freq_for_heatmap(IE,foi,oscillation_type);
data = foi_struct.data;
[ntime,ncond,nchan,nsubj] = size(data);
for m = 1:ncond
    new_data = zeros(nchan,ntime,nsubj);
    for i = 1:nchan
        for j = 1:ntime
            for p = 1:nsubj
                new_data(i,j,p) = data(j,m,i,p);
            end
        end
    end

    EEG.data = new_data;
    EEG.data_avg = mean(new_data,3);
    
    if net_type==1
        EEG.chanlocs = 'GSN-HydroCel-129.sfp';
    else
        EEG.chanlocs = 'GSN129.sfp';
    end
    
    %if net_type == 1
    %    EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Hydrocell_Chan129.loc';
    %else
    %    EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Chan129.loc';
    %end
    EEG.xmin = IE.times(1)/1000;
    EEG.xmax = IE.times(length(IE.times))/1000;
    EEG.nbchan = nchan;
    if ~isempty(IE.group_name)
        EEG.setname = strcat(IE.group_name, '_', oscillation_type,'_',foi_struct.name_for_plot,'_',IE.category_names{m});
    else
        EEG.setname = strcat(oscillation_type,'_',foi_struct.name_for_plot,'_',IE.category_names{m});
    end
    EEG.pnts = ntime;
    EEG.trials = nsubj;
    EEG.times = IE.times;
    EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];
    EEG.mean = mean(EEG.data_avg(:));
    EEG.std = std(EEG.data_avg(:));
    
    EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
    if strcmp(oscillation_type,'ITC')==1
        EEG.limit = [0, EEG.abs];
    else
        EEG.limit = [-EEG.abs,EEG.abs];
    end
    ALLEEG(m) = EEG;
end

if ncond==2
    EEG.data = ALLEEG(1).data-ALLEEG(2).data;
    EEG.data_avg = mean(EEG.data,3);
    EEG.mean = mean(EEG.data_avg(:));
    EEG.std = std(EEG.data_avg(:));
    EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
    EEG.limit = [-EEG.abs,EEG.abs];
    category_diff_name = ['diff(',IE.category_names{1}, '-', IE.category_names{2},')'];
    if ~isempty(IE.group_name)
        EEG.setname = strcat(IE.group_name, '_', oscillation_type,'_',foi_struct.name_for_plot,'_',category_diff_name);
    else
        EEG.setname = strcat(oscillation_type,'_',foi_struct.name_for_plot,'_',category_diff_name);
    end
    
    EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];
    ALLEEG(3) = EEG;
end
end

%id_type=1, first number as id
%id_type=2, everything before the first . as id
%id_type=3, TS specific, two types, Hxxx uses id_type=1, otherwise
%everything till the second dot(.).

%20180514, modified to make oscillation_type flexible
function foi_struct = get_one_freq_for_heatmap(IE,foi,oscillation_type)
    foi_index = find_valid_pos(foi,IE.freqs);

    f1 = IE.freqs(foi_index(1));
    f2 = IE.freqs(foi_index(2));

    name_for_plot = [num2str(f1), 'to' num2str(f2), 'Hz'];
    fprintf('frequency of interest is adjusted to:\n%s\n', name_for_plot);
    
    name_for_column = [dot2p(num2str(f1)) '_' dot2p(num2str(f2)), 'Hz'];
    
    foi_struct.type = oscillation_type;
    foi_struct.foi = [f1,f2];
    foi_struct.name_for_plot = name_for_plot;
    foi_struct.name_for_column = name_for_column;
    foi_struct.category_names = IE.category_names;

    foi_struct.data = squeeze(mean(IE.(oscillation_type)(foi_index(1):foi_index(2),:,:,:,:),1)); %data: times * nc *ns * chan
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
function IE2 = get_2_conditions(IE,selected_conditions)

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
    
end


IE2.(IE2.oscillation_type) = IE.(IE.oscillation_type)(:,:,selected_conditions,:,:);

end