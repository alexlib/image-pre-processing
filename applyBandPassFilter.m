function IMAGE_OUT = applyBandPassFilter(IMAGE_IN, CUTOFF_RADIUS, FILTER_TYPE)
% IMAGE_OUT = applyBandPassFilter(IMAGE_IN, CUTOFF_RADIUS, FILTER_TYPE)
% This function performs a band-pass filter on 2D color or grayscale images.
% The returned image IMAGE_OUT is of the same size and class as the input
% image IMAGE_IN.
%
% A band pass filter sets the spatial frequencies of an image Fourier
% transform to zero where the spatial frequency coordinate is greater (low-pass)
% than or less than (high-pass) some radius. 
%
% INPUTS:
%   IMAGE_IN = [M x N x C] matrix containing the intensity values of the
%       input image, where M is the number of rows in the
%       image (in pixels), N is the number of columns, and C is the
%       number of color channels (e.g., C = 3 for RGB images, and
%       C = 1 for grayscale images). 
%
%   CUTOFF_RADIUS = Scalar specifying the radius above or below which the 
%       image FFT is set to zero.
%
%   FILTER_TYPE = String specifying whether to perform high pass or low
%       pass filtering. Acceptable inputs are 'HIGH_PASS' or 'LOW_PASS'. 
%       Other input strings will cause an error.
%
% OUTPUTS:
%   IMAGE_OUT = [M x N x C] matrix containing the intensity values of the 
%   filtered image.
%
% EXAMPLE:
%   Apply a low-pass filter to a color image.
%   The result should be a blurred version of the input image.
%   The image "mandrill.png" was included with this file.
%
%   % Load an image
%   IMAGE_IN = imread('mandrill.png');
% 
%   % Set a cutoff radius of 40 for the low pass filter
%   CUTOFF_RADIUS = 40;
% 
%   % Perform the filtering operation.
%   IMAGE_OUT = bandPassFilter(IMAGE_IN, CUTOFF_RADIUS, 'LOW_PASS');
% 
%   % Show the original and filtered images side by side.
%   % Display the input image.
%   subplot(1, 2, 1); 
%   imshow(IMAGE_IN);
%   title('Input image', 'FontSize', 16);
% 
%   % Display the output image.
%   subplot(1, 2, 2);
%   imshow(IMAGE_OUT);
%   title('Output image','FontSize', 16);
% 


% The first section of this function creates a high-pass or low-pass filter
% which will be multiplied by the Fourier Transform of the image. 

% This sets the default filter type to high pass.
if nargin < 3
    FILTER_TYPE = 'HIGH_PASS';
else
    % This makes sure the filter type is specified in
    % upper-case, which simplifies using a case structure
    % to pick between high pass and low pass filters.
    FILTER_TYPE = upper(FILTER_TYPE);
end

% Measure the image dimensions
[image_height_pixels, image_width_pixels, number_of_channels] = size(IMAGE_IN);

% This creates the coordinate grid for the FFT. 
% The horizontal and vertical coordinates Fourier transforms are 
% conventially called "u" and "v", and represent the horizontal
% and vertical wave numbers, respectively.
[u, v] = meshgrid(1 : image_width_pixels, 1 : image_height_pixels);

% These are the row and column positions of the zero-frequency
% component in each direction of the 2D Fourier Transform. 
% In Matlab, the zero-frequency u pixel is located at the column position
% (region_width_pixels / 2 + 1) for images with an even number of columns, 
% and at (region_width_pixels / 2 + 0.5 for images with an odd number of
% colums; and similarly for the zero-frequency v pixel for images with
% even or odd numbers of rows. 
uc = image_width_pixels  / 2 + 1 - 0.5 * mod(image_width_pixels,  2);
vc = image_height_pixels / 2 + 1 - 0.5 * mod(image_height_pixels, 2);

% This converts the cartesian (u, v) components
% to polar to (theta, r) components, with r = 0 coincident
% with the pixel located at (uc, vc).
% The coordinate 'theta' is not set because it isn't
% used anywhere in this function.
[~, r] = cart2pol(u - uc, v - vc);

% This initializes a filter. The FT of the image will
% be multiplied by this filter to perform the band-pass operation
spectral_filter = ones(image_height_pixels, image_width_pixels);

% This sets the filter values equal to 0 in the blocked region
% of the Fourier transform, and 1 elsewhere. This is the band-pass filter
% itself.
switch FILTER_TYPE
    case 'HIGH_PASS'
        
        % This sets the wave numbers equal to zero where the radial coordinate 
        % of the FT is less than the cutoff radius measured from (uc, vc)
        spectral_filter(r < CUTOFF_RADIUS) = 0;
   
    case 'LOW_PASS'
        
        % This sets the wave numbers equal to zero where the radial coordinate 
        % of the FT is greater than the cutoff radius measured from (uc, vc)
        spectral_filter(r > CUTOFF_RADIUS) = 0;
        
    otherwise
        error(sprintf('Error: Invalid filter type specified.\nSpecify either HIGH_PASS or LOW_PASS'));
end

% Now that the filter has been created, the image is transformed using the
% Fourier Transform, then multiplied by the filter, and finally inverse
% transformed.

% This determines the class of the input image, so that the output image
% can be made to have the same class.
image_class = class(IMAGE_IN);

% This creates a matrix to hold the output image.
IMAGE_OUT = zeros(image_height_pixels, image_width_pixels, number_of_channels, image_class);

% The instructions within this loop are performed once for every image
% color channel. The loop loops over the color channels.
for k = 1 : number_of_channels
    
    % This calculates the 2-D FFT of the image color channel.
    % The function fftn is used instead of fft2 because fftn is faster.
    image_fft = fftn(double(IMAGE_IN(:, :, k)), [image_height_pixels, image_width_pixels]);

    % This shifts the zero-frequency component of the image FFT to the center
    % of the domain.
    image_fft_shift = fftshift(image_fft);

    % This multiplies the FFT of the image by the spectral filter.
    % This step is the actual application of the high- or low-pass filter.
    image_fft_filtered = image_fft_shift .* spectral_filter;

    % This line performs two steps: first putting the zero-frequency component
    % back at the (1,1) pixel rather than at (vc, uc), and secondly, taking the
    % inverse Fourier transform of the filtered FFT. This returns the filtered
    % image.
    % The word "double" in this variable name indicates that 
    % the data is stored in double-precision format, i.e., 64 bits per pixel.
    image_out_double = ifftn(fftshift(image_fft_filtered), [image_height_pixels, image_width_pixels], 'symmetric');

    % This sets the output image color channel to have the same
    % class as the input image.
    IMAGE_OUT(:, :, k) = cast(image_out_double, 'like', IMAGE_IN);

end

end






