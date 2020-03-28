clear;
oim1 = imread('img/01.jpg');
oim2 = imread('img/ref.jpg');

[r,c,n] = size(oim1);

if n == 3
    oim1 = rgb2gray(oim1);
end

[r,c,n] = size(oim2);
if n == 3
    oim2 = rgb2gray(oim2);
end

[fim1,dim1] = vl_sift(single(oim1));
[fim2,dim2] = vl_sift(single(oim2));
[matches,scores] = vl_ubcmatch(dim1,dim2);

im1_Points = fim1(1:2,matches(1,:));
im2_Points = fim2(1:2,matches(2,:));

figure;
showMatchedFeatures(oim1, oim2, im1_Points', ...
    im2_Points', 'montage');

[tform, inside_im1_Points, inside_im2_Points] = ...
    estimateGeometricTransform(im1_Points', im2_Points', 'affine');

figure;
showMatchedFeatures(oim1, oim2, inside_im1_Points, ...
    inside_im2_Points, 'montage');

boxPolygon = [1, 1;size(oim1, 2), 1;size(oim1, 2), size(oim1, 1);... 
        1, size(oim1, 1);1, 1];
    
newBoxPolygon = transformPointsForward(tform, boxPolygon);

figure;
subplot(1,2,1),imshow(oim1);
subplot(1,2,2);
imshow(oim2);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');

    
    
%{
im1 = imresize(oim1,[300 300]);
im2 = imresize(oim2,[300 300]);

figure;
imagesc(cat(2, im1, im2)) ;

xa = fim1(1,matches(1,:));
xb = fim2(1,matches(2,:)) + size(im1,2);
ya = fim1(2,matches(1,:));
yb = fim2(2,matches(2,:));

hold on;
h = line([xa ; xb], [ya ; yb]);
set(h,'linewidth', 1, 'color', 'b');

vl_plotframe(fim1(:,matches(1,:)));
fim2(1,:) = fim2(1,:) + size(im1,2);
vl_plotframe(fim2(:,matches(2,:)));
axis image off;
%}