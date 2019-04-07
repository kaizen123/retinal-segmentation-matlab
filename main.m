% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
orthogonalLength = 3; % Length of orthogonal line score
originalFilename = 'DRIVE/01_test.tif'; % Original image file path
fovMaskFilename = 'DRIVE/01_test_mask.gif'; % Image mask file path
weights = [1 1 1]; % Weights for features (line, orthogonal, greyscale)

original = imread(originalFilename);
fovMask = logical(imread(fovMaskFilename));
inverseGreen = imcomplement(original(:, :, 2));
masked = inverseGreen .* uint8(fovMask);
lineMasks = generateMaskArray(kSize, resolution, orthogonalLength);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
vectors = convolve(masked, kSize, 2, func); % First, second feature vectors
vectors(:, :, 3) = rgb2gray(original); % Third feature vector
weighted = bsxfun(@times, reshape(weights, [1 1 3]), vectors);
weighted = sum(weighted, 3); % Sum weighted feature vectors
result = vectors(:, :, 1);
inverseResult = imcomplement(result);

montage([masked result inverseResult]);
