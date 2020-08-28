%data, freqs x times x cond(3)
%plot each condition
%doesn't matter how many conditions, but need to adjust size

function ITC_images_for_3cond(times, freqs, data, cond_names,limit)

n_cond = size(data,3);
tick = 200;
xtick_min = ceil(times/tick)*tick;
xtick_max = ceil(times(length(times))/tick)*tick;

if n_cond ~= length(cond_names)
    fprintf('number of conditions not match\n');
    return;
end

fontsize = 15;

%diff = data(:,:,1)-data(:,:,2);

if nargin==4
    limit = [min(min(min(data))),max(max(max(data)))];
%    diff_limit = [min(min(min(diff))),max(max(max(diff)))];
end

figure;

%plot condition 1
for i = 1:n_cond
    h=subplot(1,3,i);
    imagesc(times,freqs,data(:,:,i),limit);
    title(cond_names{i},'fontsize',fontsize);
    set(gca,'ydir','normal','fontsize',fontsize,'xtick',xtick_min:tick:xtick_max);
    xlabel('Time(ms)');
    ylabel('Frequency(Hz)');
    colorbar;
    enlarge_plot(h,-0.05);
end

end

function enlarge_plot(h,xchange)
size = get(h,'position');
size2 = size;
size2(1) = size(1) + xchange;
size2(3) = size(3) * 1.6;
set(h,'position',size2);
end