# full head oscillation(fho) demo
1. Make sure the data is in data/raw/ folder
3. Set up parameters in data/raw/params.m
4. Go to scripts_fho/scripts/ to run create_job_related_files.m
5. No longer need to change run_fho.m to fit every project
6. Transfer the project folder to the cluster using scp, in this case Rdoc_face_fho/
scp -r -p -i ~/.ssh/farnam_rsa /Users/wu/Desktop/RESEARCH/Rdoc_2020/Rdoc_face_fho jw646@farnam.hpc.yale.edu:/ysm-gpfs/home/jw646/project/fho/
7. log in farnam
8. make an 'out' folder within the project folder on the cluster, and cd to it
8. open jobs/job_list_run_command.txt, copy and paste the commands on the command line of the 'out' folder
