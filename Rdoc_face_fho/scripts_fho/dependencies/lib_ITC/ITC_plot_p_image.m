%pvalue in format: freqs x times
function ITC_plot_p_image(times,freqs,pvalue)

bmap(1,:)=[1,0,0];
bmap(2,:)=[1,0.5,0];
bmap(3:20,1)=1;
bmap(3:20,2)=1;
bmap(3:20,3)=1;

imagesc(times,freqs,pvalue,[0,1]);
colormap(bmap);

set(gca,'ydir','normal','yTick',floor(min(freqs)):ceil(max(freqs)),...
    'fontsize',15);
xlabel('Times (ms)');
ylabel('Frequency (Hz)');
colorbar
