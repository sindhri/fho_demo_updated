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
%20170227, updated program to take IE with only 1 condition
%20171106, the data structure from the icapipeline is different
%because it was recomposed by subject by condition
%the old way, condition was ahead of channel because all conditions were
%calculated together
%old: freq x time x cond x chan x subj
%new, set: freq x time x chan x cond x subj
%20171106, run slow, added more text notifications
%fixed a bug about additional category names carried on to the oscillation
%data that have only 2 condition selected
%modify the structure, average on subject first to avoid memory load
%also prepare all conditions, leave selecting conditions to the step 2

%20171108, mark the dimension for condition

function foi_struct = ITC_prepare_data_for_heatmap_step1(IE,foi)
    foi_index = find_valid_pos(foi,IE.freqs);
    
    oscillation_type = IE.oscillation_type;

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
    foi_struct.times = IE.times;
    foi_struct.group_name = IE.group_name;
    
    if strcmp(oscillation_type,'ERSP')
        fprintf('averging across subjects.\n');
        data = mean(IE.ERSP,5);
        fprintf('averaging over frequencies\n');
        foi_struct.data = squeeze(mean(data(foi_index(1):foi_index(2),:,:,:),1)); %data: times * ns *nc * chan
    elseif strcmp(oscillation_type,'ITC')
        fprintf('averging across subjects.\n');
        data = mean(IE.ITC,5);
        fprintf('averaging over frequencies\n');
        foi_struct.data = squeeze(mean(data(foi_index(1):foi_index(2),:,:,:),1)); %data: times * ns *nc * chan
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

