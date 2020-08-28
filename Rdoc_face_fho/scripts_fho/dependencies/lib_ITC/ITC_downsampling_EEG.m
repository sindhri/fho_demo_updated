%need to downsampling from 1000hz to 250hz
%changes of field: 
%pnts
%srate
%times
%data [nbchan, pnts,trials], second dimension
%
function EEG = ITC_downsampling_EEG(EEG, target_rate)

srate = EEG.srate;
factor = srate/target_rate;
factor_round= round(factor);
fprintf('downsampling from %d Hz to %d Hz\n',EEG.srate,target_rate);

if factor ~= factor_round
    fprintf('factor %.2f rounded to %d\n',factor,factor_round);
end

EEG.times = downsample(EEG.times,factor_round);
EEG.srate = target_rate;
EEG.pnts = length(EEG.times);
[nbchan,~,trials] = size(EEG.data);
data_downsampled = zeros(nbchan,EEG.pnts,trials);

fprintf('downsampling......done\n')
for i = 1:nbchan
    for j = 1:trials
        data = EEG.data(i,:,j);
        data_downsampled(i,:,j) = downsample(data,factor_round);
    end
end

EEG.data = data_downsampled;
end