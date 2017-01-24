function [ output_args ] = task1( debug )
%TASK1 
%   Arguments:
%       - debug: 1 or 0. If 1, it will show the block matching steps.

    image1 = imread('../dataset_flow/training/image_0/000045_10.png');
    image2 = imread('../dataset_flow/training/image_0/000045_11.png');
    
    optical_flow(image1, image2, debug);

end

