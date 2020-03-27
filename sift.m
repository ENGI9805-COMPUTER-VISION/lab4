function [f, d] = sift(I, keypoint)
% SIFT - Scale-Invariant Feature Transform.
%
% Usage:    [f, d] = sift(I, keypoint)
%
% Arguments:
%           I             - I is a gray-scale image in single precision.
%           keypoint      - Interesting points of the image.
%
% Returns:
%           f             - SIFT frames.
%           d             - d is the descriptor of the corresponding frame
%           in f.

    fc = keypoint';
    [h, w] = size(fc);
    fc = cat(1, fc, zeros(1, w));
    
    [f, d] = vl_sift(I,'frames',fc, 'orientations') ;
    d = double(d');
    f = double(f(1:2,:)');
end