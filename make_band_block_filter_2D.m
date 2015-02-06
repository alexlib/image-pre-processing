function FILTER = make_band_block_filter_2D(IMAGE_HEIGHT, IMAGE_WIDTH, ...
    CUTOFF_MIN, CUTOFF_MAX)
% This function creates a circular band-pass filter to be applied to the
% Fourier Transform (FT) of a 2-D image. Multiplying this filter
% element-wise by the 2-D FT of an image preserves only the features whose
% corresponding spectral wave numbers fall between CUTOFF_MIN and
% CUTOFF_MAX. A typical use of a band-block filter could be to
% suppress only those features that are represented by a specific range 
% of wave numbers. This could be used to preserve only the
% background and noise present in an image. A band-block filter is exactly
% the inverse of a band-pass filter.
%
% INPUTS
%   IMAGE_HEIGHT = Height (number of rows) of the filter in pixels
%       (integer). This should be the same as the height of the FT of
%       the image to be filtered.
%
%   IMAGE_WIDTH = Width (number of columns) of the filter in pixels
%       (integer). This should be the same as the width of the FT of
%       the image to be filtered.
%
%   CUTOFF_MIN = Lesser of the two cutoff frequencies that specify
%       the radial filter (positive number). The filter is set to zero 
%       for radial coordinates less than CUTOFF_MIN.
%
%   CUTOFF_MAX = Greater of the two cutoff frequencies that specify
%       the radial filter (positive number). The filter is set to zero 
%       for radial coordinates greater than than CUTOFF_MAX.
%
% OUTPUTS
%   FILTER = Array with IMAGE_HEIGHT rows and IMAGE_WIDTH columns
%       representing the band-block filter. 
%
% SEE ALSO
%   make_high_pass_filter_2D, make_low_pass_filter_2D, 
%   make_band_pass_filter_2D

% Invert a band-pass filter to create a band-block filter.
FILTER = 1 - make_band_pass_filter_2D(IMAGE_HEIGHT, IMAGE_WIDTH, ...
    CUTOFF_MIN, CUTOFF_MAX);

end


