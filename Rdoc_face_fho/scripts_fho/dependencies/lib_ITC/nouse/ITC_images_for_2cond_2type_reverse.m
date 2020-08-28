%data_struct is from ITC_calculation_struct
%name_group_info is used to identify groups, eg, exposed, control
%
function ITC_images_for_2cond_2type_reverse(data_struct)

times = data_struct.times;
freqs = data_struct.freqs;

%ERSP
data = data_struct.ERSP_mean;
ITC_images_for_2cond_reverse(times,freqs,data,data_struct.ERSP_category);

%ITC
data = data_struct.ITC_mean;
ITC_images_for_2cond_reverse(times,freqs,data,data_struct.ITC_category);
