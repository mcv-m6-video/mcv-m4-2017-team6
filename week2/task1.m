function [ ] = task1()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    HIGHWAY_SEQ = [1050, 1350];
    FALL_SEQ = [1460, 1560];
    TRAFFIC_SEQ = [950, 1050];
    MODELING_RATIO = 0.5;

    IN_PATH = '../highway/input/';
    % Model the highway sequence
    n_samples = int32( (HIGHWAY_SEQ(2) - HIGHWAY_SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(IN_PATH, HIGHWAY_SEQ, n_samples);
    disp('MODELING DONE');
    
    disp('BACKGROUND ESTIMATION');
    task1_bg_estimation(IN_PATH, HIGHWAY_SEQ, meanP, varP, n_samples);
    
    
    
end

