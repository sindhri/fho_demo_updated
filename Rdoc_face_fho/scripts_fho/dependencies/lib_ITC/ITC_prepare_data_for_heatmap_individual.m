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

%20170619, the individual file approach, 
%input foi_struct that has the foi data
%just need to put into the EEGLAB format
%20180711, added oscillation_type field

function [ALLEEG_ERSP,ALLEEG_ITC] = ITC_prepare_data_for_heatmap_individual(foi_struct,net_type,...
    selected_conditions)

    ncond = length(foi_struct.category_names);

    if ncond>1
        if nargin==2
            selected_conditions = [1,2];   
        end
        foi_struct = get_2_conditions(foi_struct,selected_conditions);
    end

    ALLEEG_ERSP = compose_EEG_structure(foi_struct,'ERSP',net_type);
    ALLEEG_ITC = compose_EEG_structure(foi_struct,'ITC',net_type);

end

function ALLEEG = compose_EEG_structure(foi_struct,oscillation_type,net_type)

    data = foi_struct.(oscillation_type);
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
            EEG.chanlocs = readlocs('GSN-HydroCel-129minus3.sfp');
        else
            EEG.chanlocs = readlocs('GSN129minus3.sfp');
        end
    
    %if net_type == 1
    %    EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Hydrocell_Chan129.loc';
    %else
    %    EEG.chanlocs = 'Documents/MATLAB/work/lib_basic/lib_plot/chan_location/Chan129.loc';
    %end
        EEG.xmin = foi_struct.times(1)/1000;
        EEG.xmax = foi_struct.times(length(foi_struct.times))/1000;
        EEG.nbchan = nchan;
        if ~isempty(foi_struct.group_name)
            EEG.setname = strcat(foi_struct.group_name, '_', oscillation_type,'_',...
                foi_struct.name_for_plot,'_',foi_struct.category_names{m});
        else
            EEG.setname = strcat(oscillation_type,'_',foi_struct.name_for_plot,'_',foi_struct.category_names{m});
        end
        EEG.pnts = ntime;
        EEG.trials = nsubj;
        EEG.times = foi_struct.times;
        EEG.range = [min(EEG.data_avg(:)),max(EEG.data_avg(:))];
        EEG.mean = mean(EEG.data_avg(:));
        EEG.std = std(EEG.data_avg(:));
    
        EEG.abs = max(abs(EEG.mean - 2*EEG.std), abs(EEG.mean+2*EEG.std));
        EEG.oscillation_type = oscillation_type;
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
        category_diff_name = ['diff(',foi_struct.category_names{1}, '-', foi_struct.category_names{2},')'];
        if ~isempty(foi_struct.group_name)
            EEG.setname = strcat(foi_struct.group_name, '_',...
                oscillation_type,'_',foi_struct.name_for_plot,'_',category_diff_name);
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


%get the specific 2 condition from multiple. need to split all the fields
function foi_struct2 = get_2_conditions(foi_struct,selected_conditions)

    if length(foi_struct.category_names)==2 && selected_conditions(1)==1 && selected_conditions(2)==2
        foi_struct2 = foi_struct;
        return
    end

    if length(selected_conditions) ~=2
        fprintf('can only pick 2 conditions! Abort.\n')
        return
    end

    foi_struct2 = foi_struct;
    for i = 1:length(selected_conditions)
        foi_struct2.category_names{i} = foi_struct.category_names{selected_conditions(i)};    
    end

    foi_struct2.ERSP = foi_struct.ERSP(:,selected_conditions,:,:);
    foi_struct2.ITC = foi_struct.ITC(:,selected_conditions,:,:);

end