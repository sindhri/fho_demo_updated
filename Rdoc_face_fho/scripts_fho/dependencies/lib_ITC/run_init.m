category_names = {'draw','win'};
id_type = 1;
ITC_count_trials(category_names,1);


%oscillation calculation, test baseline,
%different baseline showed very little difference
%decided to use -1000 to -200
%category_names = {'draw','win'};
%baseline = 1000;
%id_type = 1;
%
%group_name = '';
%freq_limits = [3,30];
%pathname = '/Users/lindamayes/Desktop/Projects/KristenMorie/balloon/Oscillation/';
%path_data = [pathname 'raw_test/'];
%vbaselines = {[-1000,-200],[-600,-200],[-1000,0],[-600,0],[-400,-100],[-400,0],[-300,-200],[-300,0]};
%result_foldernames = {'result1/','result2/','result3/',...
%    'result4/','result5/','result6/','result7/','result8/'};
%for i = 1:length(result_foldernames)
%    ITC_single_file_vbaseline(category_names,baseline,...
%        vbaselines{i},group_name,id_type,freq_limits,...
%    path_data,[pathname result_foldernames{i}]);
%end


pathname = '/Users/lindamayes/Desktop/Projects/KristenMorie/balloon/Oscillation/';
group_names = {'NCE','PCE'};
vbaseline = [-600,-200];
freq_limits = [3,30];
for i = 1:length(result_foldernames)
    path_data = [pathname 'raw/' group_names{i} '/'];
    result_foldername = [pathname 'result_' group_names{i} '/'];
    ITC_single_file_vbaseline(category_names,baseline,...
        vbaseline,group_name{i},id_type,freq_limits,...
    path_data,result_foldername);
end

