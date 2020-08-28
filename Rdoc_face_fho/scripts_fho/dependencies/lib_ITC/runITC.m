%plot, theta
foi=[4,8];
oscillation_type = 'ITC';
items = -200:100:500;
net_type = 2;
%NCE
ITC_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_theta_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ITC_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_theta_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_theta_for_plot_NCE, items, print_labels);
%PCE
ITC_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_theta_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ITC_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_theta_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_theta_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-2.7,2.7];
limit_diff = [-0.58,0.58];
ITC_fullhead_heatmap(ITC_theta_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_theta_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ITC_theta_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_theta_for_plot_PCE, items, 1,limit,limit_diff);






%plot, alpha
foi=[8,12];
oscillation_type = 'ITC';
items = -200:100:500;
net_type = 2;
%NCE
ITC_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_alpha_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ITC_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_alpha_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_alpha_for_plot_NCE, items, print_labels);
%PCE
ITC_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_alpha_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ITC_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_alpha_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_alpha_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-2.7,2.7];
limit_diff = [-0.58,0.58];
ITC_fullhead_heatmap(ITC_alpha_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_alpha_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ITC_alpha_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_alpha_for_plot_PCE, items, 1,limit,limit_diff);



%plot, beta
foi=[13,30];
oscillation_type = 'ITC';
items = -200:100:500;
net_type = 2;
%NCE
ITC_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_beta_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ITC_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_beta_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_beta_for_plot_NCE, items, print_labels);
%PCE
ITC_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ITC_beta_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ITC_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ITC_beta_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ITC_beta_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-1,1];
limit_diff = [-1,1];
ITC_fullhead_heatmap(ITC_beta_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_beta_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ITC_beta_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ITC_beta_for_plot_PCE, items, 1,limit,limit_diff);







%export data of interest of all frequency, 
%for NCE
cluster.channel = [68,79,87,78, 86, 80, 82];
cluster.name = 'RIGHT_posterior';
poi = [4,8,240,350];
export_text= 'n';
doi1_NCE = ITC_fullhead_create_doi(ITC_NCE,cluster,poi,export_text);
doi1_PCE = ITC_fullhead_create_doi(ITC_PCE,cluster,poi,export_text);
%t test only mean significant
cluster.channel = [12,5,11,6,13,4,21];
cluster.name = 'Frontocentral';
poi = [8,12,250,350];
export_text= 'n';
doi2_NCE = ITC_fullhead_create_doi(ITC_NCE,cluster,poi,export_text);
doi2_PCE = ITC_fullhead_create_doi(ITC_PCE,cluster,poi,export_text);
%t tests not significant
cluster.channel = [36,30,35,29,42,37];
cluster.name = 'Left temporal';
poi = [13,30,100,200];
export_text= 'n';
doi3_NCE = ITC_fullhead_create_doi(ITC_NCE,cluster,poi,export_text);
doi3_PCE = ITC_fullhead_create_doi(ITC_PCE,cluster,poi,export_text);
%combine all three dois
doi_temp_NCE = ITC_combine_export_2doi(doi1_NCE,doi2_NCE);
doi_ITC_NCE = ITC_combine_export_2doi(doi_temp_NCE,doi3_NCE);
doi_temp_PCE = ITC_combine_export_2doi(doi1_PCE,doi2_PCE);
doi_ITC_PCE = ITC_combine_export_2doi(doi_temp_PCE,doi3_PCE);
balloon_doi_ERSP = ITC_combine_export_2doi_add_case(doi_ITC_NCE,doi_ITC_PCE);

save balloon_doi_ITC balloon_doi_ITC;