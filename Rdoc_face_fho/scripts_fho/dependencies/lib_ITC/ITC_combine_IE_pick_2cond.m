%pick condition 1 from IE1, pick condition2 from IE2
%combine them as one IE
%for comparing one condition across two groups
%can not be used for further stats. 

function IE3 = ITC_combine_IE_pick_2cond(IE1,pick1,IE2,pick2)
    if IE1.montage_channel ~= IE2.montage_channel
        fprintf('montage inconsistent, cannot pick conditions\n');
        IE3 = [];
        return
    end
    [nfreqs,ntimes,~,~] = size(IE1.ERSP);
    IE3 = IE1;
    cond_name1 = IE1.category_names{pick1};
    cond_name2 = IE2.category_names{pick2};
    if strcmp(cond_name1,cond_name2)==1
        IE3.group_name = cond_name1;
    else
        IE3.group_name = '';
    end
    
    data1.ERSP = IE1.ERSP(:,:,pick1,:);
    data2.ERSP = IE2.ERSP(:,:,pick2,:);
    data1.ITC = IE1.ITC(:,:,pick1,:);
    data2.ITC = IE2.ITC(:,:,pick2,:);
    
    IE3.ERSP = [];
    IE3.ITC = [];
    IE3.ERSP_mean = zeros(nfreqs,ntimes,2);
    IE3.ERSP_mean(:,:,1) = mean(data1.ERSP,4);
    IE3.ERSP_mean(:,:,2) = mean(data2.ERSP,4);
    IE3.ITC_mean = zeros(nfreqs,ntimes,2);
    IE3.ITC_mean(:,:,1) = mean(data1.ITC,4);
    IE3.ITC_mean(:,:,2) = mean(data2.ITC,4);

    IE3.id = [];
    IE3.category_names = {IE1.category_names{pick1},IE2.category_names{pick2}};
    IE3.ERSP_category = {IE1.ERSP_category{pick1},IE2.ERSP_category{pick2}};
    IE3.ITC_category = {IE1.ITC_category{pick1},IE2.ITC_category{pick2}};
    

    
end