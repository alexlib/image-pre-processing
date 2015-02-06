function run_spectral_filter_job_list(JOBLIST)

% Count the number of jobs in the job list
number_of_jobs = length(JOBLIST);

% Run each job in the job list.
for k = 1 : number_of_jobs
   run_spectral_filter_job_file(JOBLIST(k)); 
end

end