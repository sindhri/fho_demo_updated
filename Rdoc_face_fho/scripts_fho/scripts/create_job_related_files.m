%20200825, run params to get:
%project_folder_name
%id_type

%20200319, added additional level of fho on the cluster
%20171030
%20180712
function create_job_related_files

params; %get project_folder_name and id_type

current_path = [fileparts(which('create_job_related_files.m')) filesep];
file_separators = find(current_path == filesep);
n_file_separators = length(file_separators);
path_project = current_path(1:file_separators(n_file_separators-2));
%path_scripts = current_path(1:file_separators(n_file_separators-1));
path_data = [path_project 'data' filesep 'raw' filesep];
path_results = [path_project 'data' filesep 'result' filesep];
path_jobs = [path_project 'jobs' filesep];
if exist(path_jobs,'dir')~=7
    mkdir(path_jobs);
end

id_list = make_id_list(path_data,path_results, id_type);
fprintf('%d id found\n',length(id_list));

%make 1 test job
make_sh(project_folder_name,'y',id_list{1},path_jobs);
make_job_list(project_folder_name, 'y',id_list{1},path_jobs);

for i = 1:length(id_list)
    make_sh(project_folder_name,'n',id_list{i},path_jobs);
end
[job_list_name,job_list_name_noext] = make_job_list(project_folder_name, 'n',id_list,path_jobs);


fid = fopen([path_jobs job_list_name_noext '_run_command.txt'],'w');
fprintf(fid,'module load dSQ\n');
fprintf(fid,['dSQ.py --submit --jobfile /ysm-gpfs/home/jw646/project/fho/' project_folder_name '/jobs/' job_list_name]);
fclose(fid);
end

%20171030
%201807

function make_sh(project_folder_name, testmode,subject_ID,path_jobs)

if testmode == 'y'
    fid = fopen([path_jobs subject_ID '_test.sh'],'w');
else
    fid = fopen([path_jobs subject_ID '.sh'],'w');
end

fprintf(fid,'#!/usr/bin/bash\n');
fprintf(fid,'#SBATCH -J %s\n',subject_ID);
fprintf(fid,'#SBATCH -n 1\n');
if testmode == 'y'
    fprintf(fid,'#SBATCH -t 00:05:00\n');
else
    fprintf(fid,'#SBATCH -t 05:00:00\n');
end
fprintf(fid,'#SBATCH -N 1\n');
fprintf(fid,'#SBATCH --mem-per-cpu=8g\n');
fprintf(fid,'#SBATCH -c 4\n');
fprintf(fid,'module load MATLAB/2019b\n');
fprintf(fid,['matlab -nodisplay -nojvm -nosplash -nodesktop -r "addpath(''/ysm-gpfs/home/jw646/project/fho/' project_folder_name '/scripts_fho/scripts/'');run_fho(''' testmode ''',''' subject_ID ''');exit;"\n']);
fclose(fid);

end

%20171030
%201807, added path_job, job_list_name_noext
%20180712, added 1 test case

function [job_list_name,job_list_name_noext] = make_job_list(project_folder_name, testmode,...
    id_list,path_jobs)
job_list_name_noext = 'job_list';
job_list_name = 'job_list.txt';

for i = 1:length(id_list)
    if testmode == 'y';
        fid = fopen([path_jobs job_list_name_noext '_test.txt'],'w');
        if iscell(id_list)
            filename = [id_list{i} '_test.sh'];
        else
            
            filename = [id_list '_test.sh'];
        end
    else
        fid = fopen([path_jobs job_list_name_noext '.txt'],'a');
        filename = [id_list{i} '.sh'];
    end
    content = ['sbatch /ysm-gpfs/home/jw646/project/fho/' project_folder_name '/jobs/' filename '\n'];
    fprintf(fid,content);
end
fclose(fid);
end

%20171030
%201807
%20200825, use global find_id
function id_list = make_id_list(data_folder,result_folder, id_type)
foldername = data_folder;
foldername2 = result_folder;
filelist = dir(foldername);
id_list = cell(1);
m = 1;
for i = 1:length(filelist)
    temp = filelist(i).name;
    if strcmp(temp(1),'.')~=1 && strcmp(temp(length(temp)-3:length(temp)),'.raw')
       filename = temp;
       id = find_id(id_type, filename);
       if ~exist([foldername2 id '_oscillation.mat']);
           id_list{m} = id;
           m = m+1;
       end
    end
end
end

%20200825, use the global find_id to determine id
