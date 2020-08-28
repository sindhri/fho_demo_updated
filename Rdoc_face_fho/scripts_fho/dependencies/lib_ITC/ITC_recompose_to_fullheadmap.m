%20180711
%20180713, added group_name
function [foi_ERSP,foi_ITC] = ITC_recompose_to_fullheadmap(foi,path_result,net_type,items,group_name)

if nargin==4
    group_name = '';
end

foi_struct = ITC_fullhead_recompose_individual(foi,path_result,group_name);
[foi_ERSP,foi_ITC] = ITC_prepare_data_for_heatmap_individual(foi_struct,net_type);%prepare data for plotting
ITC_fullhead_heatmap_auto(foi_ERSP, items);
ITC_fullhead_heatmap_auto(foi_ITC,items);

end