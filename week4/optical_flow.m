function [ output_args ] = optical_flow( past, current )
%OPTICAL_FLOW Summary of this function goes here
%   Detailed explanation goes here

    block_size = 16; % Typically 16x16 pixels
    area_of_search = 48; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'fwd';
    % Forward: All pixels in the past image are associated to a  pixel in the current image
    % Backward: All pixels in the current image are associated to a pixel in the past image    
    
    n_rows = size(past,1);
    n_cols = size(past,2);
    
    % Get the number of blocks per column and row
    
    n_blocks_row = floor(n_rows/block_size);
    n_blocks_col = floor(n_cols/block_size);
    
    flow = zeros(n_blocks_row, n_blocks_col, 2);
    
    %Idea: in the bucle use im1, or im2 as variable, and define im1 and im2
    % depending on whether it is forward or backward compensation
    
    for row_block=0:block_size:n_rows-block_size
        for col_block = 0:block_size:n_cols-block_size          
            past_block = past(row_block+1:row_block+block_size, col_block+1:col_block+block_size);
            [flow_row, flow_col] = block_flow(past_block, current, area_of_search, row_block, col_block);
            
            current_row = floor(row_block/block_size) +1;
            current_col = floor(row_block/block_size) +1;
            
            flow(current_row, current_col,:) = [flow_row, flow_col];
        end
    end

end

function [flow_row, flow_col] = block_flow(block, image, area_of_search, row_position, col_position)
    block_size = size(block, 1);
    
    n_rows = size(image,1);
    n_cols = size(image,2);
    
    % Compare the given block with all the blocks in the image
    % restricting by area of search
    
    row_center = floor(row_position+block_size/2);
    col_center = floor(col_position+block_size/2);
    
    % how many pixels in each side of the block to compare
    each_side = floor(area_of_search/2);
    
    lower_bound_rows = max(0, row_center-each_side);
    lower_bound_cols = max(0, col_position-each_side);
    
    upper_bound_rows = min(n_rows-block_size, row_center+each_side);
    upper_bound_cols = min(n_cols-block_size, col_center+each_side);
    
    min_dist = Inf;
    flow_row = 0;
    flow_col = 0;
    for row_block=lower_bound_rows:block_size:upper_bound_rows
        for col_block = lower_bound_cols:block_size:upper_bound_cols
            compare_with = image(row_block+1:row_block+block_size, col_block+1:col_block+block_size);
            
            % Compute Euclidean distance
            diff = block-compare_with; % subtract
            diff = diff.^2; % square
            diff = sum(diff(:)); % sum
            diff = sqrt(diff); %square root
            
            if diff < min_dist
                min_dist = diff;
                flow_row = row_position - row_block;
                flow_col = col_position - col_block;
            end
            
        end
    end
    
end
