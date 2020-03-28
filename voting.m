clear;
oim1 = imread('img/03.jpg');
oim2 = imread('img/ref.jpg');

[row1,col1,n] = size(oim1);

if n == 3
    oim1 = rgb2gray(oim1);
end

[row2,col2,n] = size(oim2);
if n == 3
    oim2 = rgb2gray(oim2);
end

[fim1,dim1] = vl_sift(single(oim1));
[fim2,dim2] = vl_sift(single(oim2));
[matches,scores] = vl_ubcmatch(dim1,dim2);

[sv, indx] = sort(scores, 'ascend');
match_offs = matches(:, indx);
offs1 = match_offs(1, 1:10);
offs2 = match_offs(2, 1:10);

im1_points = fim1(:,offs1);
im2_points = fim2(:,offs2);

figure;
showMatchedFeatures(oim1, oim2, im1_points(1:2,:)', ...
    im2_points(1:2,:)', 'montage');

ref = [1;1];
top_left = normalize(ref,im1_points,im2_points,row2,col2);

ref = [1;col1];
top_right = normalize(ref,im1_points,im2_points,row2,col2);

ref = [row1;1];
bottom_left = normalize(ref,im1_points,im2_points,row2,col2);

ref = [row1;col1];
bottom_right = normalize(ref,im1_points,im2_points,row2,col2);

corners = [top_left;top_right;bottom_right;bottom_left];

corners_maxi = max(corners);
[corners_mini,ind] = min(corners);
dim = corners_maxi - corners_mini;

%[r,c] = size(im1_points);

%row1 = (im2_points(3,c)/im1_points(3,c)).*row1;
%col1 = (im2_points(3,c)/im1_points(3,c)).*col1;

%row1 = row1*1.2;col1 = col1*1.2;

figure;
imshow(oim2);
hold on;
rectangle('Position',[corners_mini(1) corners_mini(2) dim(2) dim(1)],'EdgeColor','g');
%line(corners(:, 1), corners(:, 2), 'Color', 'y');
