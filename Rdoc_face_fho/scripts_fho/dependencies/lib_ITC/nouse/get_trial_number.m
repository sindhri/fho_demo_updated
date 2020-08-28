%if accidentally delete the trial_number file. use it to restore a matlab
%variable and copy and paste...

trial_number = zeros(length(alleeg),3);
for i = 1:length(alleeg)
    eeg = alleeg(1,i);
    trial_number(i,1) = str2double(eeg.id);
    trial_number(i,2) = eeg.category_names_count{1,2};
    trial_number(i,3) = eeg.category_names_count{2,2};
end