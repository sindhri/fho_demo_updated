%20130306, added d
%plot t on row 1
%plot p 
%plot d
function ITC_posthoc_plot(t,p,d,category_names,times,freqs,extra_name)
    
    n = size(category_names,1);
    nrow = ceil(sqrt(n));
    ncol = ceil(n/nrow);
    if n==3
        nrow =1;
        ncol=3;
    end
    
    
    %plot p on one figure
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)/2]);
    for i = 1:n
        subplot(nrow,ncol,i);
        ITC_plot_p_image(times,freqs,p(:,:,i));
        title([extra_name ' posthot p values ' category_names{i}]);
    end
    
    %plot t on a different figure
    limit = [min(min(min(t))),max(max(max(t)))];

    figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)/2]);
    for i = 1:n
        subplot(nrow,ncol,i);
        ITC_plot_Fd_image(times,freqs,t(:,:,i),limit);
        title([extra_name ' posthoc t values ' category_names{i}]);        
    end
    
    %plot d on a different figure
    limit = [min(min(min(d))),max(max(max(d)))];

    figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)/2]);
    for i = 1:n
        subplot(nrow,ncol,i);
        ITC_plot_Fd_image(times,freqs,d(:,:,i),limit);
        title([extra_name ' posthoc d values ' category_names{i}]);        
    end
end