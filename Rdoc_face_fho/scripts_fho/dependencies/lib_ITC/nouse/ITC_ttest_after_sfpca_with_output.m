%input data, averaged ERSP or ITC based on time and frequency of interest
%time and frequency of interest are obtained from pca results

%only test the condition difference, only allows 2 conditions
%paired samples t test

%data format, freq x time x cond x subj
%20130707, save a text file with the data
%added ignore factors <3%
%type_of_data, either ITC or ERSP, for labeling

function [data_out,label] = ITC_ttest_after_sfpca_with_output(data,factor_time,factor_time_peak,...
    factor_freq,factor_freq_peak,variance,category_names,subject_list,type_of_data)

n_tpca = size(factor_time,1);
n_fpca = size(factor_freq,1)/n_tpca;

m = 1;
label = {};
data_out = [];

label{1} = 'SID';
for i = 1:n_tpca
    if factor_time(i,1)==0 && factor_time(i,2)==0
        continue;
    end
    for j = 1:n_fpca
        position = (i-1)*n_fpca+j;
        if factor_freq(position,1)==0 && factor_freq(position,2)==0
            continue;
        end
        if variance(position) < 0.03
            continue;
        end
        data_temp = squeeze(data(position,i,:,:));
        data_out(m:m+1,:) = data_temp;
        label{m+1} = [type_of_data '_TF' num2str(i) 'SF' num2str(j) category_names{1}];
        label{m+2} = [type_of_data '_TF' num2str(i) 'SF' num2str(j) category_names{2}];
        m = m + 2;
        [h,p,~,stats] = ttest(data_temp(1,:),data_temp(2,:));
        fprintf('temporal factor %d, %d to %d ms,peak %d ms\n',...
            i,factor_time(i,1),factor_time(i,2),factor_time_peak(i));
        fprintf('spectral factor %d, %.2f to %.2f Hz,peak %.2f Hz\n',...
            j,factor_freq(position,1),factor_freq(position,2),...
            factor_freq_peak(position));
        fprintf('variance %2.2f%%\n',variance(position)*100);
        print_t_result(h,p,stats);
        fprintf('\n');
    end
end

data_out = data_out'; %convert to each subject is a row, each condition is a col
data_out = [subject_list data_out];
ITC_export_to_text_using_dataset(data_out, label);