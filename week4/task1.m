function [ output_args ] = task1( input_args )
%TASK1 Summary of this function goes here
%   Detailed explanation goes here

    image1 = imread('../dataset_flow/training/image_0/000045_10.png');
    image2 = imread('../dataset_flow/training/image_0/000045_11.png');
    
    optical_flow(image1, image2);

end

