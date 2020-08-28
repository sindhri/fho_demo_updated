%pvalue in format: freqs x times
function ITC_plot_Fd_image(times,freqs,data,limit)

if nargin==3
    limit = [min(min(min(data))),max(max(max(data)))];
end

imagesc(times,freqs,data,limit);
colormap('default');

set(gca,'ydir','normal','yTick',floor(min(freqs)):ceil(max(freqs)),...
    'fontsize',15);
xlabel('Times (ms)');
ylabel('Frequency (Hz)');
colorbar
