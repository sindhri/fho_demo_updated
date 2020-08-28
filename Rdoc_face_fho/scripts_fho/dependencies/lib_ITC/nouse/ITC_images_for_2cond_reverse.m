%data, freqs x times x cond(2)
%plot each condition, and the difference (1-2)
function ITC_images_for_2cond_reverse(times, freqs, data, cond_names,limit,...
    diff_limit)

fontsize = 15;

diff = data(:,:,2)-data(:,:,1);

if nargin==4
    limit = [min(min(min(data))),max(max(max(data)))];
    diff_limit = [min(min(min(diff))),max(max(max(diff)))];
end

figure;

%plot condition 1
h1=subplot(1,3,1);
imagesc(times,freqs,data(:,:,2),limit);
title(cond_names{2},'fontsize',fontsize);
set(gca,'ydir','normal','fontsize',fontsize,'xtick',-500:100:500);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h1,-0.09);

%plot condition 2
h2=subplot(1,3,2);
imagesc(times,freqs,data(:,:,1),limit);
title(cond_names{1},'fontsize',fontsize);
set(gca,'ydir','normal','fontsize',fontsize,'xtick',-500:100:500);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h2,-0.04);

%plot difference
h3=subplot(1,3,3);
imagesc(times,freqs,diff,diff_limit);
title([cond_names{2} '-' cond_names{1}],'fontsize',fontsize);
set(gca,'ydir','normal','fontsize',fontsize,'xtick',-500:100:500);
xlabel('Time(ms)');
ylabel('Frequency(Hz)');
colorbar;
enlarge_plot(h3,0.01);
end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 2;
set(h,'position',size2);
end