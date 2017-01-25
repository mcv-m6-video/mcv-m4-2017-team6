function [ ] = task1_3(debug)
%TASK1
    addpath('HS')
    image1 = imread('../dataset_flow/training/image_0/000045_10.png');
    image2 = imread('../dataset_flow/training/image_0/000045_11.png');
    
    % Compute optical flow with Horn and Schunk method
    alpha = 1; % I took the default matlab parameters (alpha, max ites)
    ite = 10;
    [u, v] = HS(image1, image2, alpha, ite, 0, 0, 0, 0);
    if debug
        visualize_optical_flow(u, v, image2);
    end
    
    % Load optical flow GT
    gt_flow = imread('../dataset_flow/training/flow_noc/000045_10.png');   
    
    % Compute error
    [mse, pepn, error] = getError(gt_flow, u, v);
    
end

