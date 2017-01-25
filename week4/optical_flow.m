function [ flow ] = optical_flow( past, current, block_size, area_of_search, compensation, debug )
%OPTICAL_FLOW Summary of this function goes here
%   Detailed explanation goes here

    % Dimensions of the images
    n_rows = size(past,1);
    n_cols = size(past,2);
    
    % Empty structure to save the flow vectors
    flow = zeros(n_rows, n_cols, 2);
    
    % Define source and target image depending on the compensation
    % for forward: we search the blocks in the past image (source) in the
    % current frame (target)
    % for backward: we search the blocks in the current image (source) in
    % the past frame (target)
    if compensation == 'fwd'
        source = past;
        target = current;
    elseif compensation == 'bwd'
        source = current;
        target = past;
    end
    
    % Iterate for every block in the source image
    for row_block=0:block_size:n_rows-block_size
        for col_block = 0:block_size:n_cols-block_size
            % Get the block of the source frame we want to find in the
            % target
            source_block = source(row_block+1:row_block+block_size, col_block+1:col_block+block_size);
            
            % To visualize the block matching algorithm
            if debug
                imshow(source);
                hold on
                rectangle('Position',[col_block, row_block, block_size, block_size],'edgeColor','red');
                hold off;
                waitforbuttonpress;
            end
            
            % Run the block mathcing algorithm to find the source block in
            % the target image
            [flow_row, flow_col] = block_matching(source_block, target, area_of_search, row_block, col_block, debug);
            
            % The block matching algorithm returns a single vector for the
            % block. Copy this vector to all the pixels belonging to the
            % block
            flow(row_block+1:row_block+block_size, col_block+1:col_block+block_size,1) = repmat(flow_row, block_size);
            flow(row_block+1:row_block+block_size, col_block+1:col_block+block_size,2) = repmat(flow_col, block_size);
        end
    end
    
    % Visualize optical flow with quiver
%     downsample = 10; % Show 1 optical flow vectors every 'downsample' pixels
%     for i=1:size(flow, 1)
%        for j=1:size(flow,2)
%            if(mod(j,downsample) ~= 0 || mod(i,downsample)~=0)
%                flow(i,j,1) = 0;
%                flow(i,j,2) = 0;
%            end
%        end
%     end
%     imshow(target);
%     hold on
%     quiver(1:size(flow,2), 1:size(flow,1), flow(:,:,1), flow(:,:,2),20);
%     set(gca,'Ydir','reverse')
%     hold off

end

function [flow_row, flow_col] = block_matching(block, image, area_of_search, row_position, col_position, debug)
    % This function is the block matching algorithm
    % It recieves:
    %   - block: the block to match
    %   - image: image to find the block in
    %   - area_of_search: number of pixels in each side
    %   - row_position: current position of the block
    %   - col_position: current position of the block
    
    block_size = size(block, 1);
    
    % size of the image
    n_rows = size(image,1);
    n_cols = size(image,2);
    
    % We have tp Compare the given block restricting by area of search
    
    % Define the lower and upper bound of the search area in both
    % dimensions
    lower_bound_rows = max(0, row_position-area_of_search);
    lower_bound_cols = max(0, col_position-area_of_search);
    
    upper_bound_rows = min(n_rows-block_size, row_position+area_of_search);
    upper_bound_cols = min(n_cols-block_size, col_position+area_of_search);
    
    % To visualize the block matching algorithm
    if debug
        imshow(image);
        hold on
    end
    
    % convert to double because the Euclidean distance
    % will fail if not
    block = double(block);
    
    min_dist = Inf;
    flow_row = 0;
    flow_col = 0;
    
    % Step of the sliding window that search for the matching block
    step_window = 1;
    
    % Sliding window loop: compare given block against all possible blocks
    for row_block=lower_bound_rows:step_window:upper_bound_rows
        for col_block = lower_bound_cols:step_window:upper_bound_cols
            % Get current block to compare
            compare_with = double(image(row_block+1:row_block+block_size, col_block+1:col_block+block_size));
            
            % Compute Euclidean distance
            diff = block-compare_with; % subtract
            diff = diff.^2; % square
            diff = sum(diff(:)); % sum
            diff = sqrt(diff); %square root
            
            % To view the block matching algorithm
            if debug
                rectangle('Position',[col_block, row_block, block_size, block_size],'edgeColor','green');
            end
            
            % If the distance is the best until now, update the matched
            % block information
            if diff < min_dist
                min_dist = diff;
                flow_row = row_block - row_position; % row flow vector
                flow_col = col_block - col_position; % column flow vector
                best_pos_row = row_block;
                best_pos_col = col_block;
            end
            
        end
    end
    % to visualize the block matching algorithm
    if debug
        rectangle('Position',[best_pos_col, best_pos_row, block_size, block_size],'edgeColor','blue');
        waitforbuttonpress;
    end
    [flow_row, flow_col]
end

