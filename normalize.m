function [point] = normalize(ref,im1_Points,im2_Points,row2,col2)
    [r,c] = size(im1_Points);

    for i=1:c
        localrel1(i,:) = ref - im1_Points(1:2,i);
        theta = im2_Points(4,i) - im1_Points(4,i);
        ori = [cos(theta) -sin(theta);sin(theta) cos(theta)];
        localrel2(i,:) = im2_Points(1:2,i) + (im2_Points(3,i)/im1_Points(3,i)).*ori*localrel1(i,:)';
    end
    
    point = mapping(localrel2,row2,col2,c);
end