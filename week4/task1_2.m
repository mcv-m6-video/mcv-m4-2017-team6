function [ output_args ] = task1_2( debug )
%TASK1 
%   Arguments:
%       - debug: 1 or 0. If 1, it will show the block matching steps.

    image1 = imread('../dataset_flow/training/image_0/000157_10.png');
    image2 = imread('../dataset_flow/training/image_0/000157_11.png');
    
    % Best fwd: block 24, area 8
    % Best bwd: bock 32, area 8
    
    block_size = 32; % Typically 16x16 pixels
    area_of_search = 8; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'fwd'; % options 'fwd' or 'bwd'
    % Forward: All pixels in the past image are associated to a  pixel in the current image
    % Backward: All pixels in the current image are associated to a pixel in the past image
    
    flow_result = optical_flow(image1, image2, block_size, area_of_search, compensation, debug);
    visualize_optical_flow(flow_result(:,:,1), flow_result(:,:,2), image2)
    waitforbuttonpress;
    gt_flow = imread('../dataset_flow/training/flow_noc/000157_10.png');
    
    [mse, pepn, error] = getError(gt_flow, flow_result(:,:,1), flow_result(:,:,2));
    
    [mse, pepn]
    
    % Now get the lucasKanade results
    
    [LKu, LKv] = LucasKanade(image1, image2);
    
    visualize_optical_flow(LKu, LKv, image2)
    waitforbuttonpress;
    
    [mse, pepn, error] = getError(gt_flow, LKu, LKv);
    
    [mse, pepn]

end

