%20141202
%makes heatmap provided the ALLEEG structure
%each EEG is for a condition
%EEG.data dimension follows nchanxntimexnsubj
%items are the time point for plotting
function ITC_fullhead_heatmap_1cond(ALLEEG, items,print_labels)

if nargin==2
    print_labels = 0;
end

ncond = length(ALLEEG);

%range = [min([ALLEEG(1).range,ALLEEG(2).range]),...
%    max([ALLEEG(1).range,ALLEEG(2).range])];
data_mean = ALLEEG(1).mean;
data_temp = ALLEEG(1).data_avg;
data_std = ALLEEG(1).std;
data_abs = ALLEEG(1).abs;
limit = [-data_abs,data_abs];

for i = 1:ncond
    if i==1 || i==2
    %cannot use 'absmax' or'maxmin', has to either omit it or use a
    %specific limit, otherwise it only applies the limit on the very last
    %graph
        if print_labels == 0
            pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit);
        else
            pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',limit,'electrodes','numbers');
        end
    else
        if print_labels == 0
           pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',ALLEEG(i).limit);
        else
            pop_topoplot(ALLEEG(i),1,items,ALLEEG(i).setname,[1,length(items)],'maplimits',ALLEEG(i).limit,'electrodes','numbers');
        end
    end
end
end