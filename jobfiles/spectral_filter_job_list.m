function JOBLIST = spectral_filter_job_list();
% JOBLIST = spectral_filter_job_list()
% This function creates and batch-processing structure that contains
% a list of individual image-filtering jobfile sub-structures. It takes
% no inputs, and its output should be passed as an argument to the
% function run_spectral_filter_job_list(JOBLIST).
% 
% INPUTS:
%   None. This function accepts no input arguments. Instead, 
%    job file parameters for each job are specified within the
%    body of this function. Here you can modify specific
%    fields of the JobFile structure, each of which is explained
%    in the comments of the function spectral_filter_default_jobfile. 
%
% OUTPUTS:
%   JOBLIST = Structure containing sub-structures that each
%             specify the processing parameters of an individual
%             image filtering jobs.
%
% SEE ALSO
%   spectral_filter_default_jobfile, run_spectral_filter_job_list

% Begin function %

% Load the default job
DefaultJob = spectral_filter_default_jobfile;

% Copy the default job parameters to a temporary variable.
JobFile = DefaultJob;

% Edit parameters as needed
JobFile.Parameters.FilterType = 'high_pass';
JobFile.Parameters.CutoffWaveNumber_01 = 10;
JobFile.Parameters.CutoffWaveNumber_02 = 25;
JobFile.Files.Inputs.FirstImageNumber  = 10;
JobFile.Files.Inputs.LastImageNumber   = 39;

% Save the job item to the job list
JOBLIST(1) = JobFile;

% Copy the default job parameters to a temporary variable.
JobFile = DefaultJob;

% Edit parameters as needed
JobFile.Files.Inputs.Directory = '~/Documents/School/VT/Research/Aether/siv/analysis/data/flat_point_electrodes_gap_10mm/raw';
JobFile.Parameters.FilterType = 'high_pass';
JobFile.Parameters.CutoffWaveNumber_01 = 10;
JobFile.Parameters.CutoffWaveNumber_02 = 25;
JobFile.Files.Inputs.FirstImageNumber  = 10;
JobFile.Files.Inputs.LastImageNumber   = 39;
JOBLIST(end + 1) = JobFile;


end 












