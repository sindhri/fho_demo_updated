%pick pick certain conditions out of all, from teh same IE 
%for example pick = [1:5]

function IE2 = ITC_pick_n_cond(IE1,pick)
    
    IE2 = IE1;
    IE2.ERSP = IE1.ERSP(:,:,pick,:);
    IE2.ERSP_mean = mean(IE2.ERSP,4);
    IE2.ITC = IE1.ITC(:,:,pick,:);
    IE2.ITC_mean = mean(IE2.ITC,4);
    IE2.category_names = cell(1);
    IE2.ERSP_category = cell(1) ;
    IE2.ITC_category = cell(1);
    
    for i = 1:length(pick)
        IE2.category_names{i} = IE1.category_names{pick(i)};
        IE2.ERSP_category{i} = IE1.ERSP_category{pick(i)};
        IE2.ITC_category{i} = IE1.ITC_category{pick(i)};
    end
    
end