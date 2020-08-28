%add more subjects
function IE = ITC_combine_IE(IE1, IE2)
    [~,~,~,nsubj1] = size(IE1.ERSP);
    [~,~,~,nsubj2] = size(IE2.ERSP);
    
    IE = IE1;
    
    for i = nsubj1+1:nsubj1+nsubj2
        IE.ERSP(:,:,:,i) = IE2.ERSP(:,:,:,i-nsubj1);
        IE.ERSP_mean = mean(IE.ERSP,4);
        IE.ITC(:,:,:,i) = IE2.ITC(:,:,:,i-nsubj1);
        IE.ITC_mean = mean(IE.ITC,4);
        IE.id{i} = IE2.id{i-nsubj1};
    end
end