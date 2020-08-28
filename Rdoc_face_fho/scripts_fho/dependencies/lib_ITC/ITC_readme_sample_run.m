chan_list = [11 12 5 6];
category_names = {'Lose1s','Gain1s','Lose2s','Gain2s'};
baseline = 1000;


alleeg = ITC_read_egi(category_names,baseline);

IE = ITC_calculation(alleeg,'',chan_list);

%ITC_images_for_2cond(IE.times, IE.freqs, IE.ERSP_mean(:,:,1:2),{'Lose1s(ERSP)', 'Gain1s(ERSP)'});
ITC_images_for_2cond(IE);
%or
ITC_images_for_3cond(IE);


%calculate values
poi_ERSP = [4,8,200,400;...
    8,12,100,250;...
    12.5,16,300,450;...
    8.5,12,450,550;];
poi_ITC = [4,8,100,250;...
    8,12,50,250;];

doi_ERSP = ITC_create_doi(IE,poi,'ERSP','export?y/n','montage_name','group_name');

doi_ITC = ITC_create_doi(IE,poi,'ITC','export?y/n','montage_name','group_name');

ITC_combine_export_2doi(doi_ERSP,doi_ITC);