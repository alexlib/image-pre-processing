function JOBLIST = spectral_filter_job_list();

% Load the default job
DefaultJob = spectral_filter_default_jobfile;

% Copy the default job parameters to a temporary variable.
JobFile = DefaultJob;

% Edit parameters as needed
JobFile.Parameters.FilterType = 'band_pass';
JobFile.Parameters.CutoffWaveNumber_01 = 5;
JobFile.Parameters.CutoffWaveNumber_02 = 25;
JobFile.Files.Inputs.FirstImageNumber  = 10;
JobFile.Files.Inputs.LastImageNumber   = 39;

% Save the job item to the job list
JOBLIST(1) = JobFile;

end 












