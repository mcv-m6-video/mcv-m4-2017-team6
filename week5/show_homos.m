function [ output_args ] = show_homos( path , orig, frames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %orig = [246 1; 342 1; 68 328; 499 328];
    %orig = [219 1; 275 1; 1 204; 254 204];
    for i=1:1700
        img = imread(strcat(path, 'in00', sprintf('%04d',i), '.jpg'));
        imshow(homo(img, orig));
        pause(0.0000001)
    end
end

