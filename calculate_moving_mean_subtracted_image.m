function IMAGE_OUT = calculate_moving_mean_subtracted_image...
    (IMDIR, IMBASE, IMEXT, NDIGITS, IMAGE_NUM, WINDOW_SIZE)

% Force the window size to be an odd number
WINDOW_SIZE = WINDOW_SIZE + 1 - mod(WINDOW_SIZE, 2);

% Window radis
win_radius = max(1, (WINDOW_SIZE - 1) / 2);

% Start image in the series
start_image = IMAGE_NUM - win_radius;

% End number in the series
end_image = IMAGE_NUM + win_radius;

% Calculate the mean image.
IMAGE_OUT = calculate_mean_image(IMDIR, IMBASE, IMEXT, NDIGITS, ...
    start_image, end_image);


end