%output all_ERSP, all_ITC, n_freq*n_time*n_cond*n_subj
%need to modify the way of getting subject id;

%2013-01-22, adjust to only need one segmentation file
%use EEG.epoch{i}.eventcategory{1} to separate events

function [all_ERSP, all_ITC_z, all_subject,times, ...
    freqs,category_names] = ITC_calculation_single_seg(chan_list,freqs,n_freqs,n_times)

baseline = 2500;
datapoint_start = 501;
datapoint_end = 1525;

category_names = {'no effect','disgust','face'};
n_category = length(category_names);
category_names_counts = cell(n_category,3);
for i = 1:n_category
    category_names_counts{i,1} = category_names{i};
end

if nargin == 1
    chan_list = read_channelclusters;
    chan_list = chan_list{1};
    freqs = [3,30];
    n_freqs = freqs(2)-freqs(1)+1;
    n_times = 220;
end

fprintf('analysis is conducted on the following channel cluster\n');
for i = 1:length(chan_list)
    fprintf('%d\t',chan_list(i));
end
fprintf('\n');

path = [pwd '/raw/'];
listings = dir(path);
if strcmp(listings(3).name, '.DS_Store')==1
    n_extra = 3; %.,.., .DS_Store, possibly different for windows computer
else
    n_extra = 2;
end
n_subj = length(listings) - n_extra;

%n_times = 220;
%chan_list = [16 11 19 4 12 5 6];

all_ERSP = zeros(n_freqs, n_times, n_category, n_subj);
all_ITC_z = zeros(n_freqs, n_times, n_category, n_subj);
all_subject = cell(n_subj,1);


%fid = fopen('status.txt','w');
%fprintf(fid,'filename\tsubject\tcondition\t#oftrials\tcondition#\tsubject#\n');
for i = 1:n_subj
    filename = listings(i+n_extra,1).name;
%    fprintf(fid,'%s\t',filename);
    fprintf('%d\t%s\n',i,filename);
    
    %this works for stressreward
    %subject = filename(8:10);
    
    %this works for NR_2010 and ANT
    %subject = filename(1:find(filename=='_',1)-2);
    
    %for YES1
    subject = filename(1:3);
    all_subject{i} = subject;
    
%    fprintf(fid,'%s\t',subject);
    
    EEG = pop_readegi([path filename]);
    EEG.xmin = EEG.xmin - baseline/1000;
    EEG.xmax = EEG.xmax - baseline/1000;
    EEG.times = [-1500,548];
    
    
    %take care of event separation
    %first col,name, second col, counts, third, trial number
  
  
    n_trials = EEG.trials;
    for j = 1:n_category
        category_names_counts{j,2} = 0;
        category_names_counts{j,3} = [];
    end
    for j = 1:n_trials
        category = EEG.epoch(j).eventcategory{1};

        for p = 1:n_category
            if strcmp(category_names{p},category)==1        
                category_names_counts{p,2} = category_names_counts{p,2} + 1;
                category_names_counts{p,3} = [category_names_counts{p,3}, j];
                break
            end
        end
    end
    %end of event separation    
    
    %process data based on different categories
    for j = 1:n_category

        trial_index = category_names_counts{j,3};
        [ERSP,ITC,~,times,freqs]=newtimef(mean(EEG.data(chan_list,...
            datapoint_start:datapoint_end,trial_index),1), ...
        datapoint_end - datapoint_start + 1,EEG.times, EEG.srate, [3, 0.5], ...
        'nfreqs',n_freqs, 'freqs', freqs,...
       'timesout',n_times,'baseline',[-1000,0],'plotitc','off','plotersp','off');
    
   ITC_z=abs(ITC);
    
       all_ERSP(:,:,j,i) = ERSP;
       all_ITC_z(:,:,j,i) = ITC_z;
    end
    
    
    fprintf('\n');
    for j = 1:n_category
        fprintf('category %d %s, %d trials\n',j,category_names_counts{j,1},...
        category_names_counts{j,2});
    
    end    


end

%fclose(fid);
%fprintf('please refer to status.txt for detailed information.\n');