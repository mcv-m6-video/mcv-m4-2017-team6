function [ output_args ] = task1_1( debug )
%TASK1 
%   Arguments:
%       - debug: 1 or 0. If 1, it will show the block matching steps.

    image1 = imread('../dataset_flow/training/image_0/000045_10.png');
    image2 = imread('../dataset_flow/training/image_0/000045_11.png');
    
    b_sizes = [8 16 32 40 50];
    areas = [10 20];
    compensation = 'fwd';
    
    block_results = [];
    for bi = 1:length(b_sizes)
        area_results = [];
        for ai = 1:length(areas)
            block_size = b_sizes(bi);
            area_of_search = areas(ai);
            
            flow_result = optical_flow(image1, image2, block_size, area_of_search, compensation, debug);
            gt_flow = imread('../dataset_flow/training/flow_noc/000045_10.png');

            [mse, pepn, error] = getError(gt_flow, flow_result);

            [mse, pepn]
            
            area_results = [pepn area_results]
        end
        block_results = [area_results ; block_results]
    end
    
    
    
end

