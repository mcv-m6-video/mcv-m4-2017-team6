function [ output_args ] = task1_1( debug )
%TASK1 
%   Arguments:
%       - debug: 1 or 0. If 1, it will show the block matching steps.

    image1 = imread('../dataset_flow/training/image_0/000157_10.png');
    image2 = imread('../dataset_flow/training/image_0/000157_11.png');
    
    b_sizes = [8 16 24 32 40 48];
    areas = [8 16 24 32 40 48];
    compensation = 'fwd';
    
    results = [];
    for bi = 1:length(b_sizes)
        area_results = [];
        for ai = 1:length(areas)
            block_size = b_sizes(bi);
            area_of_search = areas(ai);
            
            block_size, area_of_search
            
            flow_result = optical_flow(image1, image2, block_size, area_of_search, compensation, debug);
            gt_flow = imread('../dataset_flow/training/flow_noc/000157_10.png');

            % Get error function expects: ground_truth, u, v
            [mmen, pepn, error] = getError(gt_flow, flow_result(:,:,1), flow_result(:,:,2));

            [mmen, pepn]
            
            results = [results ; mmen pepn];
        end
    end
    
    save('task1_1_results/seq_157_fwd.mat', 'results');
    
end

