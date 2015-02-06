function run_spectral_filter_job_file(JOBFILE)
% ABOUT
%%%%%%

% Parse the jobfile.
% Filter type
filter_type = JOBFILE.Parameters.FilterType;

% Filter parameters: First cutoff wave number
cutoff_wave_number_01 = JOBFILE.Parameters.CutoffWaveNumber_01;

% Optional second cutoff wave number
if isfield(JOBFILE.Parameters, 'CutoffWaveNumber_02')
    cutoff_wave_number_02 = JOBFILE.Parameters.CutoffWaveNumber_02;
else
    cutoff_wave_number_02 = [];
end

% Directory in which the input files are located.
input_image_dir = JOBFILE.Files.Inputs.Directory;

% Directory in which to save the output files.
output_image_dir = JOBFILE.Files.Outputs.Directory;

% Number of digits in the input files
input_number_of_digits = JOBFILE.Files.Inputs.NumberOfDigits;

% Number of digits in the output files.
output_number_of_digits = JOBFILE.Files.Outputs.NumberOfDigits;

% Base name of the input files
input_file_base_name = JOBFILE.Files.Inputs.BaseName;

% Base name of the output files
output_file_base_name = JOBFILE.Files.Outputs.BaseName;

% File extension of the input images
input_file_extension = JOBFILE.Files.Inputs.FileExtension;

% File extension of the output images
output_file_extension = JOBFILE.Files.Outputs.FileExtension;

% First input image number
first_input_image_number = JOBFILE.Files.Inputs.FirstImageNumber;

% First output image number
% Make sure a variable exists to specify the first output image number.
if ~isfield(JOBFILE.Files.Outputs, 'FirstImageNumber')
    first_output_image_number = [];
else
    first_output_image_number = JOBFILE.Files.Outputs.FirstImageNumber;
end

% Last input image number
last_input_image_number = JOBFILE.Files.Inputs.LastImageNumber;

% Number of images to skip
skip_images = JOBFILE.Files.Inputs.SkipImages;

% Format of numbers in the input file names
input_number_format = ['%0' num2str(input_number_of_digits) 'd'];

% Format of numbers in the output file names
output_number_format = ['%0' num2str(output_number_of_digits) 'd'];

% List of the input image numbers
input_image_list = first_input_image_number : skip_images : last_input_image_number;

% Number of images
number_of_images = length(input_image_list);

% List of the output image numbers
if isempty(first_output_image_number)
    output_image_list = input_image_list;
else
    output_image_list = first_output_image_number : ...
                        skip_images : ...
                        first_output_image_number + number_of_images - 1;
end

% This is the name of the first image 
% which will be loaded to to check the image size
input_file_name = [input_file_base_name num2str(first_input_image_number, input_number_format)...
        input_file_extension];

% This is the path to the first image
input_file_path = fullfile(input_image_dir, input_file_name);

% Load the first image to check its size
[image_height, image_width] = size(imread(input_file_path));

% Create the filter.
switch(lower(filter_type))
    case 'high_pass'
        image_filter = make_high_pass_filter_2D(image_height,...
            image_width, cutoff_wave_number_01);
    case 'low_pass'
        image_filter = make_low_pass_filter_2D(image_height,...
            image_width, cutoff_wave_number_01);
    case 'band_pass'
        if isempty(cutoff_wave_number_02)
            fprintf(1, 'Error: Band pass filter specified with only one cutoff wave number.\n');
            fprintf(1, 'Defaulting to low-pass filter.\n\n');
            image_filter = make_low_pass_filter_2D(image_height, ...
            image_width, cutoff_wave_number_01);
        else
            image_filter = make_band_pass_filter_2D(image_height,...
            image_width, cutoff_wave_number_01, cutoff_wave_number_02);
        end
    case 'band_block'
        if isempty(cutoff_wave_number_02)
            fprintf(1, 'Error: Band block filter specified with only one cutoff wave number.\n');
            fprintf(1, 'Defaulting to high-pass filter.\n\n');
            image_filter = make_high_pass_filter_2D(image_height, ...
                image_width, cutoff_wave_number_01);
        else
            image_filter = make_band_block_filter_2D(image_height,...
            image_width, cutoff_wave_number_01, cutoff_wave_number_02);
        end
        
end

% Make the output directory if it doesn't already exist.
if ~exist(output_image_dir, 'dir')
    mkdir(output_image_dir);
end

% Loop over all the images, filtering each one.
for k = 1 : number_of_images
    
    % Inform the user of the status
    fprintf('Filtering image %d of %d...\n', k, number_of_images);
    
    % Number of the current input image
    input_image_number = input_image_list(k);
    
    % Number of the current output image
    output_image_number = output_image_list(k);
    
    % File name of the current input image
    input_file_name = [input_file_base_name, num2str(input_image_number,...
        input_number_format), input_file_extension];
    
    % File name with which to save the filtered image
    output_file_name = [output_file_base_name, num2str(output_image_number,...
        output_number_format), output_file_extension];
    
    % Path to the input file
    input_file_path  = fullfile(input_image_dir,  input_file_name);
    
    % Path to the output file
    output_file_path = fullfile(output_image_dir, output_file_name);
    
    % Load the file
    input_image = imread(input_file_path);
    
    % Take the 2-D Fourier transform of the input image
    FT_raw = fftshift(fftn(double(input_image), [image_height, image_width]));
    
    % Multiply the Fourier transform by the filter!
    FT_filtered = FT_raw .* image_filter;
    
    % Take the inverse FT of the filtered FT
    filtered_image = abs(ifftn(FT_filtered, [image_height, image_width]));
       
    % Convert the filtered image to the same bit-depth as the
    % input image, then save it to disk.
    imwrite(cast(filtered_image, 'like', input_image), output_file_path);
    
    % Inform the user that the image was saved.
    fprintf('Saved filtered image to %s\n\n', output_file_path);
    
end

% Inform the user that processing is finished!
fprintf('Processing complete!\n\n');

end