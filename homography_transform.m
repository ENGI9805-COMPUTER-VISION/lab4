function [XY_] = homography_transform(XY, H)
% HOMOGRAPHY_TRANSFORM - Transforming a set of points from one image to
%                          another by H.
%
% Usage:    [XY_] = homography_transform(XY, H)
%
% Arguments:
%           XY            - A set of points in image 1.
%           H             - The homography H.
%
% Returns:
%           XY_           - The same set of points in image 2.
    Xi = cat(1, XY', ones(1, size(XY, 1))); % Concatenate arrays.
    lambdaXi_ = H*Xi;
    lambdaXi_ = lambdaXi_';
    XY_ = lambdaXi_(:,1:2);
    XY_(:,1)=XY_(:,1)./lambdaXi_(:,3);
    XY_(:,2)=XY_(:,2)./lambdaXi_(:,3);
end