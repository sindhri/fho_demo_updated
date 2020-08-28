
%export more than one data_struct?

%time_of_interest = [200,350];
%frequency_of_interest = [4,7;8,12;15,30];
%data is freqs x time x cond x subj

%20121118, added permutation input
%time frequency combination,
%permutation = 'y':every combination, 
%permutation = 'n':
%just time1+freq1, time2+freq2, etc. fewer combination is the default

%20121124, added type, might break some other program
%20140801, added extra_name
function [data_2d, data_label] = ITC_study_specific_time_freq_struct(data_struct,...
    time_of_interest,frequency_of_interest, type, permutation,extra_name)

if nargin == 5
    extra_name = '';
end

times = data_struct.times;
freqs = data_struct.freqs;
category_names = data_struct.category;
all_subject = data_struct.id;

if strcmp(type,'ERSP')==1
    data = data_struct.ERSP;
else
    if strcmp(type,'ITC')==1
        data = data_struct.ITC;
    else
        fprintf('type needs to be either ERSP or ITC. Abort\n');
        return
    end
end

if nargin==4
    permutation = 'y';
end

nt = size(time_of_interest,1);
nf = size(frequency_of_interest,1);

data_of_interest = ITC_get_data_of_interest(data, ...
    time_of_interest, frequency_of_interest, times, freqs);

%t tests
fprintf([category_names{1} ' - ' category_names{2} 'comparison: \n']);
for i = 1:nt
    t1 = time_of_interest(i,1);
    t2 = time_of_interest(i,2);

    for j = 1:nf
        if permutation == 'n' && j~=i
            continue
        end
        fprintf('time %.2f to %.2f ms',t1,t2);
        f1 = frequency_of_interest(j,1);
        f2 = frequency_of_interest(j,2);
        fprintf(' frequency %.2f to %.2f Hz\n',f1,f2);
        data = squeeze(data_of_interest(j,i,:,:));
        [h,p,~,stats] = ttest(data(1,:)',data(2,:)');
        print_t_result(h,p,stats);
    end
end

[data_2d, data_label] = ITC_export_data_of_interest_cell(data_of_interest,time_of_interest,...
    frequency_of_interest,category_names,type,all_subject,'n',extra_name);