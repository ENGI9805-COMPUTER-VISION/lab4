%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Part 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
image_files = dir(fullfile('img', '*.jpg'));
images = cell(1, 12);
for i=1:length(image_files)
    if ~isempty(regexp(image_files(i).name, '[0-9]{2}.jpg', 'match'))
        images{i} = imread(fullfile('img',image_files(i).name));
    end
end
ref_image = imread('img/ref.jpg');

[r,c,n] = size(ref_image);
if n == 3
    ref_image = rgb2gray(ref_image);
end
% Store the test image no. and number of inliers of that test image
num_of_inliers = zeros(2, 12);
max_num_of_inliers = 0;

for i=1:length(images)
    [r,c,n] = size(images{i});

    if n == 3
        images{i} = rgb2gray(images{i});
    end

    % Extract SIFT features
    [descriptor_loc1,descriptors1] = vl_sift(single(images{i}));
    [descriptor_loc2,descriptors2] = vl_sift(single(ref_image));
    % Match the reference image to each test image
    [matches,scores] = vl_ubcmatch(descriptors1, descriptors2, 1.2);

    % Get top 10 matches for each test image
    [sv, indx] = sort(scores, 'ascend');
    match_offs = matches(:, indx);
    offs1 = match_offs(1, 1:10);
    offs2 = match_offs(2, 1:10);

    im1_points = descriptor_loc1(1:2,offs1);
    im2_points = descriptor_loc2(1:2,offs2);

    % Visualize top 10 matches for each test image
    figure;
    h = showMatchedFeatures(images{i}, ref_image, im1_points', ...
        im2_points', 'montage');
    matches_IM = h.CData;
    output_file = 'result/' + string(i) + '.jpg';
    imwrite(matches_IM, output_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Part 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get the top 3 matches for each test image
    offs1 = match_offs(1, 1:3);
    offs2 = match_offs(2, 1:3);

    im1_points = descriptor_loc1(1:2,offs1);
    im2_points = descriptor_loc2(1:2,offs2);

    % Use affine transformation between the features in the two images
    [tform, inlierPoints1, inlierPoints2, status] = ...
        estimateGeometricTransform(im1_points', im2_points', 'affine');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Part 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    offs1 = match_offs(1, :);
    offs2 = match_offs(2, :);
    im1_points = descriptor_loc1(1:2,offs1);
    im2_points = descriptor_loc2(1:2,offs2);
    ransac_n = 5000;
    [num_inliers, im1_points, im2_points] = ...
        ransac(im1_points', im2_points', ransac_n, @fit_homography, @homography_transform);
    num_of_inliers(1, i) = i;
    num_of_inliers(2, i) = num_inliers;
    if max_num_of_inliers < num_inliers
        max_num_of_inliers = num_inliers;
        inlier_matches1 = im1_points;
        inlier_matches2 = im2_points;
    end
end
% Sort the test images as per the number of inliers
[val, ind] = sort(num_of_inliers(2, :), 'descend');
fileID = fopen('result/num_of_inliers.txt', 'w');
fprintf(fileID, '%8s %20s\n','No.','No of inliers');
for i=1:length(ind)
    fprintf(fileID, '\t%d\t\t %d\n', ind(i), num_of_inliers(2, ind(i)));
end
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Part 4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
boxPolygon = [1, 1;size(ref_image, 2), 1;size(ref_image, 2), ...
    size(ref_image, 1); 1, size(ref_image, 1);1, 1];
    
% Re-compute the transformation using all the inlier matches
[tform, inlierPoints1, inlierPoints2, status] = ...
    estimateGeometricTransform(inlier_matches1, inlier_matches2, 'affine');

newBoxPolygon = transformPointsForward(tform, boxPolygon);

figure;
subplot(1,2,1),imshow(ref_image);
subplot(1,2,2);
imshow(images{ind(1)});
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');

    
    
%{
im1 = imresize(image1,[300 300]);
im2 = imresize(image2,[300 300]);

figure;
imagesc(cat(2, im1, im2)) ;

xa = descriptor_loc1(1,matches(1,:));
xb = descriptor_loc2(1,matches(2,:)) + size(im1,2);
ya = descriptor_loc1(2,matches(1,:));
yb = descriptor_loc2(2,matches(2,:));

hold on;
h = line([xa ; xb], [ya ; yb]);
set(h,'linewidth', 1, 'color', 'b');

vl_plotframe(descriptor_loc1(:,matches(1,:)));
descriptor_loc2(1,:) = descriptor_loc2(1,:) + size(im1,2);
vl_plotframe(descriptor_loc2(:,matches(2,:)));
axis image off;
%}