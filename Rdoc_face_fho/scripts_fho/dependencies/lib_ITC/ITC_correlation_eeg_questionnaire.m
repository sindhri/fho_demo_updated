%20150506, get ALLEEG from ITC_prepare_data_for_heatmap, so it is for a
%specific frequency
%calculate the correlation between the signal and the questionnaire data
%use the data for final heatmap plotting

function ALLEEG_cor = ITC_correlation_eeg_questionnaire(ALLEEG,questionnaire)
[nchans,ntimes,~]=size(ALLEEG(1).data);

for i = 1:length(ALLEEG)
    fprintf('\n\ncalculating condition %d of %d...\n',i,length(ALLEEG));
    data = ALLEEG(i).data;
    data_cor = zeros(nchans,ntimes);
    data_p = zeros(nchans,ntimes);
    data_p_sign = zeros(nchans,ntimes);
    for a = 1:nchans
        if mod(a,10)==0
            fprintf('calculating chan %d...\n',a);
        end
        for b = 1:ntimes
            [R,P] = corrcoef(data(a,b,:),questionnaire);
            data_cor(a,b) = R(1,2);
            data_p(a,b)=P(1,2);
            if R(1,2)>0
                data_p_sign(a,b) = P(1,2);
            else
                data_p_sign(a,b) = -P(1,2);
            end
        end
    end
    ALLEEG_cor(i).data_cor = data_cor;
    ALLEEG_cor(i).data_p = data_p;
    ALLEEG_cor(i).data_p_sign = data_p_sign;
    ALLEEG_cor(i).chanlocs = ALLEEG(i).chanlocs;
    ALLEEG_cor(i).xmin = ALLEEG(i).xmin;
    ALLEEG_cor(i).xmax = ALLEEG(i).xmax;
    ALLEEG_cor(i).nbchan = ALLEEG(i).nbchan;
    ALLEEG_cor(i).setname_cor = [ALLEEG(i).setname ' correlation r'];
    ALLEEG_cor(i).setname_p = [ALLEEG(i).setname ' correlation p'];
    ALLEEG_cor(i).pnts = ALLEEG(i).pnts;
    ALLEEG_cor(i).times = ALLEEG(i).times;
    ALLEEG_cor(i).cor_range = [min(data_cor(:)),max(data_cor(:))];
end