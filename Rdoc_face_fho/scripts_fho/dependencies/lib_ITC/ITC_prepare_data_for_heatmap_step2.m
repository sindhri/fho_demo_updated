%only for set data structure

function ALLEEG = ITC_prepare_data_for_heatmap_step2(net_type, foi_struct)
ncond = length(foi_struct.category_names);

data = foi_struct.data;
oscillation_type = foi_struct.type;
if ncond>1
    [ntime,nchan,ncond] = size(data);
else
    [ntime,nchan] = size(data);
end

for m = 1:ncond

    fprintf('converting structure for condition %d of %d\n',m, ncond);
    new_data = zeros(nchan,ntime);
    for i = 1:nchan
        for j = 1:ntime
            if ncond>1
                    %new_data(i,j,p) = data(j,m,i,p);%old
                    new_data(i,j) = data(j,i,m);
            else
                    new_data(i,j) = data(j,i);
            end
        end
    end

    EEG.data = new_data;
    EEG.data_avg = new_data;
    
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
    EEG.oscillation_type = oscillation_type;
    EEG.category_name = foi_struct.category_names{m};
    EEG.name_for_plot = foi_struct.name_for_plot;
    EEG.group_name = foi_struct.group_name;
    EEG.xmin = foi_struct.times(1)/1000;
    EEG.xmax = foi_struct.times(length(foi_struct.times))/1000;
    EEG.nbchan = nchan;
    if ~isempty(foi_struct.group_name)
        EEG.setname = strcat(foi_struct.group_name, '_', oscillation_type,'_',foi_struct.name_for_plot,'_',foi_struct.category_names{m});
    else
        EEG.setname = strcat(foi_struct.type,'_',foi_struct.name_for_plot,'_',foi_struct.category_names{m});
    end
    EEG.pnts = ntime;
    EEG.trials = 1;
    EEG.times = foi_struct.times;
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


end