function [ output_args ] = task1_2( debug )
%TASK1 
%   Arguments:
%       - debug: 1 or 0. If 1, it will show the block matching steps.

    image1 = imread('../dataset_flow/training/image_0/000045_10.png');
    image2 = imread('../dataset_flow/training/image_0/000045_11.png');
    
    block_size = 16; % Typically 16x16 pixels
    area_of_search = 16; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'bwd'; % options 'fwd' or 'bwd'
    % Forward: All pixels in the past image are associated to a  pixel in the current image
    % Backward: All pixels in the current image are associated to a pixel in the past image
    
    flow_result = optical_flow(image1, image2, block_size, area_of_search, compensation, debug);
    gt_flow = imread('../dataset_flow/training/flow_noc/000045_10.png');
    
    [mse, pepn, error] = getError(gt_flow, flow_result);
    
    [mse, pepn]

end

