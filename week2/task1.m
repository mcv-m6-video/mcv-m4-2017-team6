function [ ] = task1(dataset_path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dataset_path = strcat(dataset_path, 'dataset/');
    
    MODEL_SEQ = [1 850];
    MODELING_RATIO = 0.5;

    % HIGHWAY sequence
    HIGHWAY_SEQ = [1050, 1350];
    HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
    
    n_samples = int32( (HIGHWAY_SEQ(2) - HIGHWAY_SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(HIGHWAY_PATH, HIGHWAY_SEQ, n_samples);
    disp('MODELING DONE');
    
    disp('BACKGROUND ESTIMATION');
    task1_bg_estimation(HIGHWAY_PATH, HIGHWAY_SEQ, meanP, varP, n_samples);
    
    % FALL sequence
    FALL_SEQ = [1460, 1560];
    FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
    
    n_samples = int32( (FALL_SEQ(2) - FALL_SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(FALL_PATH, FALL_SEQ, n_samples);
    disp('MODELING DONE');
    
    disp('BACKGROUND ESTIMATION');
    task1_bg_estimation(FALL_PATH, FALL_SEQ, meanP, varP, n_samples);
    
    % TRAFFIC sequence
    TRAFFIC_SEQ = [950, 1050];
    TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
    
    n_samples = int32( (TRAFFIC_SEQ(2) - TRAFFIC_SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(TRAFFIC_PATH, TRAFFIC_SEQ, n_samples);
    disp('MODELING DONE');
    
    disp('BACKGROUND ESTIMATION');
    task1_bg_estimation(TRAFFIC_PATH, TRAFFIC_SEQ, meanP, varP, n_samples);
end

