function IMAGEOUT = calculate_mean_image(IMDIR, IMBASE, IMEXT, NDIGITS, STARTIMAGE, ENDIMAGE);

% Number format
nFormat = ['%0' num2str(NDIGITS) '.0f'];

% Image list
imageNum = STARTIMAGE : ENDIMAGE;

% Number of images
nImages = length(imageNum);

% load first image
fileName = [IMBASE num2str(imageNum(1), nFormat) IMEXT];
filePath = fullfile(IMDIR, fileName);
imgSize = size(imread(filePath));

% Initialize sum image
IMAGEOUT = zeros(imgSize);

% Calculate the mean
for k = 1 : nImages
    
    fprintf(['Calculating mean image: ' num2str(k) ' of ' num2str(nImages) '\n'] );

    fileName = [IMBASE num2str(imageNum(k), nFormat) IMEXT];
    filePath = fullfile(IMDIR, fileName);
    
    % Check existence of the file path.
    if exist(filePath, 'file')
    
        % Read the image if it exists
        img = imread(filePath);
        
        % Add its contribution to the sum-image
        IMAGEOUT = IMAGEOUT + double(img);
    end
    
end

% Divide by the number of images to take the mean.
IMAGEOUT = IMAGEOUT ./ nImages;


end


