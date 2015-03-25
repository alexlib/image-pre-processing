function IMAGEOUT = calculate_mean_image(IMDIR, IMBASE, IMEXT, NDIGITS, STARTIMAGE, ENDIMAGE);

% Number format
nFormat = ['%0' num2str(NDIGITS) '.0f'];

% Image list
imageNum = STARTIMAGE : ENDIMAGE;

% Number of images
nImages = length(imageNum);

% Set a file-existence flag to zero
exist_flag = 0;

% Set an image counter to 1
k = 1;

% Find the first image that exists
while exist_flag == 0
    % Determine the file name of the first image
    fileName = [IMBASE num2str(imageNum(k), nFormat) IMEXT];

    % Determine the file path of the first image
    filePath = fullfile(IMDIR, fileName);
    
    % Check existence
    if exist(filePath, 'file')
        % Determine the size of the first image
        imgSize = size(imread(filePath));
        
        % Set the file-existence flag to one.
        exist_flag = 1;
    else
        k = k + 1;
    end
    
end

% Initialize sum image
IMAGEOUT = zeros(imgSize);

% Start an image counter.
% Do this because "nImages" won't accurately reflect
% the number of images if not all the images existed.
image_counter = 0;

% Calculate the mean
for k = 1 : nImages
    
    % Construct the file name
    fileName = [IMBASE num2str(imageNum(k), nFormat) IMEXT];
    
    % Construct the file path
    filePath = fullfile(IMDIR, fileName);
    
    % Check existence of the file path.
    if exist(filePath, 'file')
        
        % Increment the image counter
        image_counter = image_counter + 1;
    
        % Read the image if it exists
        img = imread(filePath);
        
        % Add its contribution to the sum-image
        IMAGEOUT = IMAGEOUT + double(img);
    end
    
end

% Divide by the number of images to take the mean.
IMAGEOUT = IMAGEOUT ./ image_counter;


end


