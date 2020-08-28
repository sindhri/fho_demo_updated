%plot the condition effect for each group
%data should be: times x freqs x cond x subj
%between is 1, 2, 3, start from 1 and count continously

function ITC_image_for_interaction(times, freqs, data, between,...
    cond_names,group_names)

n = size(data);
n_group = max(between);
data_temp = zeros([n(1:3),n_group]);
data_plot = zeros([n(1:2),n_group]);

for i = 1:n_group
    data_temp(:,:,:,i) = mean(data(:,:,:,between==i),4);
    data_plot(:,:,i) = data_temp(:,:,1,i) - data_temp(:,:,2,i);
end

limit = [min(min(min(data_plot))),max(max(max(data_plot)))];
fontsize = 15;
adjustment = [-0.09, -0.04, 0.01];
figure;
for i = 1:n_group

    h=subplot(1,n_group,i);
    imagesc(times,freqs,data_plot(:,:,i),limit);
    title([group_names{i} '   ' cond_names{1} '-' cond_names{2}],'fontsize',fontsize);
    set(gca,'ydir','normal','fontsize',fontsize,'xtick',-500:100:500);
    xlabel('Time(ms)');
    ylabel('Frequency(Hz)');
    colorbar;
    enlarge_plot(h,adjustment(i));

end
end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 2;
set(h,'position',size2);
end