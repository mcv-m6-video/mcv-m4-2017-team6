function [ ] = task2_1( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
    seq_traffic = [950, 1050];
    
    block_size = 16; % Typically 16x16 pixels
    area_of_search = 16; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'bwd'; % options 'fwd' or 'bwd'
    
    for i = seq_traffic(1) : seq_traffic(2)-1
        past = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')) );
        curr = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i+1), '.jpg')) );
        flow_result = optical_flow(past, curr, block_size, area_of_search, compensation, 0);   
        i
    end


    
    
    
    
    

end

