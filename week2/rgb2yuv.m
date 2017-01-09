function [ out ] = rgb2yuv( in )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    R = in(:,:,1);
    G = in(:,:,2);
    B = in(:,:,3);

    Y = 0.299 * R + 0.587 * G + 0.114 * B;
    U = -0.14713 * R - 0.28886 * G + 0.436 * B;
    V = 0.615 * R - 0.51499 * G - 0.10001 * B;


    out = cat(3, R, G, B);
end

