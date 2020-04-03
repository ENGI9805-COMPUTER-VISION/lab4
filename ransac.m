function [best_num_inliers, im1_points, im2_points] = ransac(XY, XY_, N, estimate_func, transform_func)
% RANSAC - A simple RANSAC implementation.
%
% Usage:    [result, best_num_inliers, residual] = ransac(XY, XY_, ransac_n, @fit_homography, @homography_transform)
%
% Arguments:
%           XY            - A seed group of points in image 1.
%           XY_           - A seed group of points in image 2.
%           N             - number of RANSAC iterations.
%           estimate_func - Function to calculate homography H.
%           transform_func- Function to transform points from one image to another.
%
% Returns:
%           best_num_inliers     The No. of inliers of the best homography
%           im1_points           The inlier matches in image 1
%           im2_points           The inlier matches in image 2


    best_H = [];
    best_num_inliers = 0;

    for i = 1:N
        % Random permutation
        ind = randperm(size(XY,1)); 
        ind_s = ind(1:4);
        ind_r = ind(5:end);

        XYs = XY(ind_s,:);
        XYs_ = XY_(ind_s,:);

        XYr = XY(ind_r,:);
        XYr_ = XY_(ind_r,:);

        H = estimate_func(XYs, XYs_);
        [XYf_] = transform_func(XYr, H);

        dists = sum((XYr_ - XYf_).^2,2);

        % inliner is defined as dist < 0.3
        ind_inl = find(dists<0.3);
        num_inliers = length(ind_inl);
        
        % found a better homography
        if best_num_inliers < num_inliers
            best_H = H;
            best_num_inliers = num_inliers;
            im1_points = XYr(ind_inl, :);
            im2_points = XYr_(ind_inl, :);
        end
    end
end