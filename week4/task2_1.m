function [ ] = task2_1( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
    seq_traffic = [950, 1050];
    
    block_size = 16; % Typically 16x16 pixels
    area_of_search = 16; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'bwd'; % options 'fwd' or 'bwd'
    
    udir_accum = 0;
    vdir_accum = 0;
    first = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',1), '.jpg')) );
    %imwrite(first,)
    for i = seq_traffic(1) : seq_traffic(2)-1
        i
        past = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')) );
        curr = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i+1), '.jpg')) );
        flow_result = optical_flow(past, curr, block_size, area_of_search, compensation, 0);   
        
        [udir_accum,vdir_accum] = motion_compensation(flow_result(:,:,1), flow_result(:,:,1), ...
                                                      udir_accum, vdir_accum);
        
        crop = 40;
        if udir_accum >= 0
            xstart = crop - udir_accum;
            xend = size(curr, 2) - crop + udir_accum;
        else
            xstart = crop - udir_accum;
            xend = size(curr, 2) - crop + udir_accum;
        end
        
        if vdir_accum >= 0
            ystart = crop - vdir_accum;
            yend = size(curr, 1) - crop + vdir_accum;
        else
            ystart = crop - vdir_accum;
            yend = size(curr, 1) - crop + vdir_accum;
        end
        corrected = curr(ystart:yend, xstart:xend);
        imwrite(corrected, strcat('traffic_corrected/', 'in00', sprintf('%04d',i), '.jpg'));
        
    end


    
    
    
    
    

end

