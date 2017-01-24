function [ output_args ] = optical_flow( past, current, debug )
%OPTICAL_FLOW Summary of this function goes here
%   Detailed explanation goes here

    block_size = 128; % Typically 16x16 pixels
    area_of_search = 1; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'fwd';
    % Forward: All pixels in the past image are associated to a  pixel in the current image
    % Backward: All pixels in the current image are associated to a pixel in the past image    
    
    n_rows = size(past,1);
    n_cols = size(past,2);
    
    % Get the number of blocks per column and row
    
    n_blocks_row = floor(n_rows/block_size);
    n_blocks_col = floor(n_cols/block_size);
    
    flow = zeros(n_rows, n_cols, 2);
    
    %Idea: in the bucle use im1, or im2 as variable, and define im1 and im2
    % depending on whether it is forward or backward compensation
    
    for row_block=0:block_size:n_rows-block_size
        for col_block = 0:block_size:n_cols-block_size          
            past_block = past(row_block+1:row_block+block_size, col_block+1:col_block+block_size);
            
            % debug
            if debug
                imshow(past);
                hold on
                rectangle('Position',[col_block, row_block, block_size, block_size],'edgeColor','red');
                hold off;
                waitforbuttonpress;
            end
            % end debug
            
            [flow_row, flow_col] = block_flow(past_block, current, area_of_search, row_block, col_block, debug);
            
            [flow_row, flow_col]
            
            flow(row_block+1:row_block+block_size, col_block+1:col_block+block_size,1) = repmat(flow_row, block_size);
            flow(row_block+1:row_block+block_size, col_block+1:col_block+block_size,2) = repmat(flow_col, block_size);
        end
    end
    
    flow1 = flow(:,:,1);
    
    downsample = 20;
    for i=1:size(flow, 1)
       for j=1:size(flow,2)
           if(mod(j,downsample) ~= 0 || mod(i,downsample)~=0)
               flow(i,j,1) = 0;
               flow(i,j,2) = 0;
           end
       end
    end
    
    imshow(current);
    hold on
    quiver(1:size(flow,2), 1:size(flow,1), flow(:,:,1), flow(:,:,2),100);
    set(gca,'Ydir','reverse')
    hold off

end

function [flow_row, flow_col] = block_flow(block, image, area_of_search, row_position, col_position, debug)
    block_size = size(block, 1);
    
    n_rows = size(image,1);
    n_cols = size(image,2);
    
    % Compare the given block with all the blocks in the image
    % restricting by area of search
    
    row_center = floor(row_position+block_size/2);
    col_center = floor(col_position+block_size/2);
    
    % how many blocks in each side of the current block to search for
    % comparison
    each_side = floor(area_of_search/block_size);
    
    lower_bound_rows = max(0, row_center-each_side*block_size);
    lower_bound_cols = max(0, col_position-each_side*block_size);
    
    upper_bound_rows = min(n_rows-block_size, row_center+each_side*block_size);
    upper_bound_cols = min(n_cols-block_size, col_center+each_side*block_size);
    
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
    
    step_window = 5;
    
    for row_block=lower_bound_rows:step_window:upper_bound_rows
        for col_block = lower_bound_cols:step_window:upper_bound_cols
            compare_with = double(image(row_block+1:row_block+block_size, col_block+1:col_block+block_size));
            
            % Compute Euclidean distance
            diff = block-compare_with; % subtract
            diff = diff.^2; % square
            diff = sum(diff(:)); % sum
            diff = sqrt(diff); %square root
            
            % debug
            if debug
                rectangle('Position',[col_block, row_block, block_size, block_size],'edgeColor','green');
            end
            % end debug
            
            if diff < min_dist
                min_dist = diff;
                flow_row = row_position - row_block;
                flow_col = col_position - col_block;
                best_pos_row = row_block;
                best_pos_col = col_block;
                most_similar = compare_with;
            end
            
        end
    end
    if debug
        rectangle('Position',[best_pos_col, best_pos_row, block_size, block_size],'edgeColor','blue');
        waitforbuttonpress;
    end
    %debug
%     imshow(most_similar);
%     waitforbuttonpress;
    % end debug
    flow_row = (flow_row + row_position)*(abs(flow_row)>0);
    flow_col = (flow_col + col_position)*(abs(flow_col)>0);
end

