%add more conditions. also was used to combine montages, also some fields
%would be wrong
%20150203, fixed a bug around getting category names, should use {} instead
%of ()
%20170320, changed IE.category to IE.category_names;
function IE = ITC_combine_IE2(IE1, IE2)
    [~,~,nc1,~] = size(IE1.ERSP);
    [~,~,nc2,~] = size(IE2.ERSP);
    
    IE = IE1;
    
    for i = nc1+1:nc1+nc2
        IE.ERSP(:,:,i,:) = IE2.ERSP(:,:,i-nc1,:);
        IE.ERSP_mean = mean(IE.ERSP,4);
        IE.ITC(:,:,i,:) = IE2.ITC(:,:,i-nc1,:);
        IE.ITC_mean = mean(IE.ITC,4);
        IE.category_names{i} = IE2.category_names{i-nc1};
        IE.ERSP_category{i} = IE2.ERSP_category{i-nc1};
        IE.ITC_category{i} = IE2.ITC_category{i-nc1};
    end
end