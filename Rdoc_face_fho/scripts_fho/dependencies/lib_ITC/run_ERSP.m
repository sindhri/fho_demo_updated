%plot, theta
foi=[4,8];
oscillation_type = 'ERSP';
items = -200:100:500;
net_type = 2;
%NCE
ERSP_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_theta_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ERSP_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_theta_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_theta_for_plot_NCE, items, print_labels);
%PCE
ERSP_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_theta_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ERSP_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_theta_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_theta_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-2.7,2.7];
limit_diff = [-0.58,0.58];
ITC_fullhead_heatmap(ERSP_theta_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_theta_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_theta_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_theta_for_plot_PCE, items, 1,limit,limit_diff);




%headplot for theta
for i = 1:length(ERSP_theta_for_plot_NCE)
    ERSP_theta_for_plot_NCE(i).splinefile = 'splinefile.txt';
end
for i = 1:length(ERSP_theta_for_plot_PCE)
    ERSP_theta_for_plot_PCE(i).splinefile = 'splinefile.txt';
end


angle = [225,45];
items = 300;
ITC_fullhead_headplot(ERSP_theta_for_plot_NCE, items,angle);
ITC_fullhead_headplot(ERSP_theta_for_plot_PCE, items, angle);
limit = [-3.9, 3.9];
%limit_diff = [-0.97, 0.97];
limit_diff = [-0.5, 0.5];
ITC_fullhead_headplot(ERSP_theta_for_plot_NCE, items,angle,limit,limit_diff);
ITC_fullhead_headplot(ERSP_theta_for_plot_PCE, items, angle,limit,limit_diff);

%limit = [-4.5,4.5];
%limit_diff = [-1.2,1.2];
%ITC_fullhead_headplot(ERSP_theta_for_plot_NCE, items,angle, print_labels,...
%    limit,limit_diff);
%ITC_fullhead_headplot(ERSP_theta_for_plot_PCE, items, angle, print_labels,...
%    limit,limit_diff);



%plot, alpha
foi=[8,12];
oscillation_type = 'ERSP';
items = -200:100:500;
net_type = 2;
%NCE
ERSP_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_alpha_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ERSP_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_alpha_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_alpha_for_plot_NCE, items, print_labels);
%PCE
ERSP_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_alpha_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ERSP_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_alpha_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_alpha_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-2.7,2.7];
limit_diff = [-0.58,0.58];
ITC_fullhead_heatmap(ERSP_alpha_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_alpha_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_alpha_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_alpha_for_plot_PCE, items, 1,limit,limit_diff);


%headplot for alpha
for i = 1:length(ERSP_alpha_for_plot_NCE)
    ERSP_alpha_for_plot_NCE(i).splinefile = 'splinefile.txt';
end
for i = 1:length(ERSP_alpha_for_plot_PCE)
    ERSP_alpha_for_plot_PCE(i).splinefile = 'splinefile.txt';
end

%items = 200; % Change to get time window for one head at a time or make all
items = 250;
%angle = [320,40];
angle = [225,45];
ITC_fullhead_headplot(ERSP_alpha_for_plot_NCE, items,angle);
ITC_fullhead_headplot(ERSP_alpha_for_plot_PCE, items, angle);
limit = [-1.3,1.3];
limit_diff= [-0.5,0.5];
ITC_fullhead_headplot(ERSP_alpha_for_plot_NCE, items,angle,limit,limit_diff);
ITC_fullhead_headplot(ERSP_alpha_for_plot_PCE, items, angle,limit,limit_diff);



%plot, beta
foi=[13,30];
oscillation_type = 'ERSP';
items = -200:100:500;
net_type = 2;
%NCE
ERSP_NCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_beta_for_plot_NCE = ITC_prepare_data_for_heatmap_single_file(ERSP_NCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_beta_for_plot_NCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_beta_for_plot_NCE, items, print_labels);
%PCE
ERSP_PCE= ITC_fullhead_recompose(oscillation_type); %pulling all the oscillation data
ERSP_beta_for_plot_PCE = ITC_prepare_data_for_heatmap_single_file(ERSP_PCE,foi,net_type); %prepare data for plotting
for i = 1:3
    ERSP_beta_for_plot_PCE(i).chanlocs = 'GSN129-3.sfp';
end
print_labels = 0;
ITC_fullhead_heatmap(ERSP_beta_for_plot_PCE, items, print_labels);
%adjust a common scale for both groups
limit = [-2.7,2.7];
limit_diff = [-0.58,0.58];
ITC_fullhead_heatmap(ERSP_beta_for_plot_NCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_beta_for_plot_NCE, items, 1,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_beta_for_plot_PCE, items, print_labels,limit,limit_diff);
ITC_fullhead_heatmap(ERSP_beta_for_plot_PCE, items, 1,limit,limit_diff);





%export data of interest of all frequency, 
%for NCE
cluster.channel = [20,21,12,11,16,18,28];
cluster.name = 'left_frontal';
poi = [4,8,240,350];
export_text= 'n';
doi1_NCE = ITC_fullhead_create_doi(ERSP_NCE,cluster,poi,export_text);
doi1_PCE = ITC_fullhead_create_doi(ERSP_PCE,cluster,poi,export_text);
%t test only mean significant
cluster.channel = [42,48,43,47,41,53,54];
cluster.name = 'left_temporal1';
poi = [8,12,200,300];
export_text= 'n';
doi2_NCE = ITC_fullhead_create_doi(ERSP_NCE,cluster,poi,export_text);
doi2_PCE = ITC_fullhead_create_doi(ERSP_PCE,cluster,poi,export_text);
%t tests not significant
cluster.channel = [36,37,30,35,29,42];
cluster.name = 'left_temporal2';
poi = [13,30,100,200];
export_text= 'n';
doi3_NCE = ITC_fullhead_create_doi(ERSP_NCE,cluster,poi,export_text);
doi3_PCE = ITC_fullhead_create_doi(ERSP_PCE,cluster,poi,export_text);
%combine all three dois
doi_temp_NCE = ITC_combine_export_2doi(doi1_NCE,doi2_NCE);
doi_ERSP_NCE = ITC_combine_export_2doi(doi_temp_NCE,doi3_NCE);
doi_temp_PCE = ITC_combine_export_2doi(doi1_PCE,doi2_PCE);
doi_ERSP_PCE = ITC_combine_export_2doi(doi_temp_PCE,doi3_PCE);
balloon_doi_ERSP = ITC_combine_export_2doi_add_case(doi_ERSP_NCE,doi_ERSP_PCE);

save balloon_doi_ERSP balloon_doi_ERSP;