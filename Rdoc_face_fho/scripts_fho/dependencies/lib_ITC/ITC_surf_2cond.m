function ITC_surf_2cond(IE)

nc = length(IE.category);
if nc~=2
    fprintf('only print surf for 2 conditions');
    return
end

ERSP_mean = IE.ERSP_mean;
ERSP_mean(:,:,3) = IE.ERSP_mean(:,:,1)-IE.ERSP_mean(:,:,2);
IE.ERSP_category{3,1} = 'ERSP diff';

for i = 1:3
    figure;
    surfc(IE.times,IE.freqs,ERSP_mean(:,:,i));
    h = gca;
    set(h,'fontsize',20,'fontname','times new roman');
    xlabel('Time (ms)');
    ylabel('Frequency (hz)');
    zlabel(IE.ERSP_category{i});
end

ITC_mean = IE.ITC_mean;
ITC_mean(:,:,3) = IE.ITC_mean(:,:,1)-IE.ITC_mean(:,:,2);
IE.ITC_category{3,1} = 'ITC diff';

for i = 1:3
    figure;
    surfc(IE.times,IE.freqs,ITC_mean(:,:,i));
    h = gca;
    set(h,'fontsize',20,'fontname','times new roman');
    xlabel('Time (ms)');
    ylabel('Frequency (hz)');
    zlabel(IE.ITC_category{i});
end
