function [ img ] = homo( img, orig )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here       
    dest = [1 1; 400 1; 1 400; 400 400];
    
    tform = fitgeotrans(orig, dest, 'projective');
    img = imwarp(img, tform);
   
    
    %img = img(:, 955:1467);
end

