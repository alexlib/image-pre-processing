function JOBLIST = spectral_filter_jobfile

% Cutoff wave number of the filter.
DefaultJob.Parameters.CutoffWaveNumber_01 = 5;

% Second cutoff wave number
% (optional; use this for band-pass and band-block filters)
% See those functions' documentation for details.
DefaultJob.Parameters.CutoffWaveNumber_02 = 25;

% Type of filter to use. Set this to one of the following options. 
% This is not case-sensitive
% DefaultJob.Parameters.FilterType = 'high_pass';
% DefaultJob.Parameters.FilterType = 'low_pass';
DefaultJob.Parameters.FilterType = 'band_pass';
% DefaultJob.Parameters.FilterType = 'band_block';

% This is the path to the directory containing the raw images
DefaultJob.Files.Inputs.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/siv/analysis/data/flat_point_electrodes_gap_10mm/raw';

% This is the path to the directory where you want to save
% the filtered images.
DefaultJob.Files.Outputs.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/siv/analysis/data/flat_point_electrodes_gap_10mm/high_pass';

% This is the base name of the raw images (everything before the number)
% e.g., for the file "raw_image_00001.tif", file_base_name == 'raw_image_';
DefaultJob.Files.Inputs.BaseName = 'jpeg1_10mm';

% This is the base name with which to save the filtered
% images e.g., for the file "filtered_image_00001.tif",
% file_base_name == 'filtered_image_';
DefaultJob.Files.Outputs.BaseName = 'flat_point_electrodes_gap_10mm_high_pass_';

% File extension of the input files (include the dot)
DefaultJob.Files.Inputs.FileExtension = '.jpg';

% File extension of the output files (include the dot)
DefaultJob.Files.Outputs.FileExtension = '.tif';

% Number of digits in the input file numbers
% e.g., for "raw_image_00001.tif", number_of_digits == 5.
DefaultJob.Files.Inputs.NumberOfDigits = 3;

% Number of digits with which to save the the filtered
% images, e.g., for "filtered_image_00001.tif", number_of_digits == 5.
DefaultJob.Files.Outputs.NumberOfDigits = 3;

% First and last image numbers
DefaultJob.Files.Inputs.FirstImageNumber = 10;
DefaultJob.Files.Inputs.LastImageNumber = 39;

% How many images to skip between successive images
% (1 means don't skip any, 2 means skip every other image, etc.)
DefaultJob.Files.Inputs.SkipImages = 1;

% Starting image number of the output images. 
% Leave this empty to output images with the same numbering
% as the input images. Otherwise, the saved images will
% start at this number.
DefaultJob.Files.Outputs.FirstImageNumber = [];

% Copy the default job parameters to a temporary variable.
JobFile = DefaultJob;

% Save the job item to the job list
JOBLIST(1) = JobFile;

end 












