%output all_ERSP, all_ITC, n_freq*n_time*n_cond*n_subj
%need to modify the way of getting subject id;

%2012-09-28
%calculate ITC from each channel

function [all_ERSP, all_ITC, all_subject,times, ...
    freqs,category_names] = ITC_calculation_fullhead(n_cond,n_chan,freqs,n_freqs,n_times)

if nargin == 1
    n_chan = 129;
    freqs = [3,30];
    n_freqs = freqs(2)-freqs(1)+1;
    n_times = 220;
end

path = [pwd '/data/'];
listings = dir(path);
if strcmp(listings(3).name, '.DS_Store')==1
    n_extra = 3; %.,.., .DS_Store, possibly different for windows computer
else
    n_extra = 2;
end
n_files = length(listings) - n_extra;

if mod(n_files,n_cond) ~=0
    fprintf('number of conditions and files are incompatible\n');
    return
else
    n_subj = n_files/n_cond;
end
%n_cond = 2;

%n_times = 220;
%chan_list = [16 11 19 4 12 5 6];

all_ERSP = zeros(n_freqs, n_times, n_cond, n_subj, n_chan);
all_ITC = zeros(n_freqs, n_times, n_cond, n_subj, n_chan);

baseline = 1000;
count = [];
count_subject = 0;
subject0 = '';
all_subject = 0;

m = 0;
category_names = {};
fid = fopen('status2.txt','w');
fprintf(fid,'filename\tsubject\tcondition\t#oftrials\tcondition#\tsubject#\n');
for i = 1:n_files
    filename = listings(i+n_extra,1).name;
    fprintf(fid,'%s\t',filename);
    fprintf('%d\t%s\n',i,filename);
    
    %this works for stressreward
    %subject = filename(8:10);
    
    %this works for NR_2010 and ANT
    subject = filename(1:find(filename=='_',1)-2);
    
    fprintf(fid,'%s\t',subject);
    
    if strcmp(subject0, subject) == 0
        count_subject = count_subject+1;
        all_subject(count_subject,1) = str2double(subject);
        subject0 = subject;
    end

    EEG = pop_readegi([path filename]);
    EEG.xmin = EEG.xmin - baseline/1000;
    EEG.xmax = EEG.xmax - baseline/1000;
    EEG.times = EEG.times - baseline;
    
    if i<=n_cond && m <n_cond
        m = m + 1;
        count = [count;0];
        category_names{m} = EEG.event(1,1).category;
    end

    condition = EEG.event(1,1).category;

    
    for j = 1:n_chan
        if mod(j,10)==0
            fprintf('processing channel %d\n',j);
        end
        [ERSP,ITC,~,times,freqs]=newtimef(mean(EEG.data(j,:,:),1), ...
            EEG.pnts,[EEG.xmin EEG.xmax]*1000, EEG.srate, [3, 0.5], ...
            'nfreqs',n_freqs, 'freqs', freqs,...
           'timesout',n_times,'baseline',[-1000,0],'plotitc','off','plotersp','off');

        ITC=abs(ITC);

        if j==1
            fprintf(fid,'%s\t%d\t',condition,EEG.trials);
        end
        for n = 1:m
            if strcmp(condition, category_names{n})==1
                count(n) = count(n) + 1;
                all_ERSP(:,:,n,count(n),j) = ERSP;
                all_ITC(:,:,n,count(n),j) = ITC;
                break;
            end
        end
        if j==1
            fprintf(fid,'%d\t%d\n',n,count(n));
        end
    end
end

fprintf('\n');
for i = 1:n_cond
    fprintf('category %d %s, %d files\n',i,category_names{i},count(i));
end

fclose(fid);
fprintf('please refer to status2.txt for detailed information.\n');