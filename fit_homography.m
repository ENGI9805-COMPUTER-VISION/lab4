function H = fit_homography(XY, XY_)
% FIT_HOMOGRAPHY - Computing the homography H.
%
% Usage:    H = fit_homography(XY, XY_)
%
% Arguments:
%           XY            - 4 points in image 1.
%           XY_           - 4 points in image 2.
%
% Returns:
%           H             - The homography H.

    [h, w] = size(XY);
    [h_, w_] = size(XY_);
    assert(h == h_);
    assert(w == 2);
    assert(w_ == 2);

    A = [];
    for i = 1:h
        Xi = [XY(i,:)'; 1];
        xi_ = XY_(i, 1);
        yi_ = XY_(i, 2);
        zs = zeros(3, 1);
        A = cat(1, A, cat(2, zs', Xi', -yi_*Xi'));
        A = cat(1, A, cat(2, Xi', zs', -xi_*Xi'));
    end

    [U, S, V] = svd(A); % Singular value decomposition.
    H = V(:,end);

    H = reshape(H, [3 3])';    
end