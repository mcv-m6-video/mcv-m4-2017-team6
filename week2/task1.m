function [ ] = task1(dataset_path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dataset_path = strcat(dataset_path, 'dataset/');
    
    HIGHWAY_SEQ = [1050, 1350];
    HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
    
    FALL_SEQ = [1460, 1560];
    FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
    
    TRAFFIC_SEQ = [950, 1050];
    TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
    
    MODEL_SEQ = [1 850];
    MODELING_RATIO = 0.5;

    % Model the highway sequence
    %n_samples = int32( (HIGHWAY_SEQ(2) - HIGHWAY_SEQ(1)) * MODELING_RATIO );
    n_samples = int32( MODEL_SEQ(2) - MODEL_SEQ(1) );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(HIGHWAY_PATH, MODEL_SEQ, n_samples);
    disp('MODELING DONE');
    
    disp('BACKGROUND ESTIMATION');
    task1_bg_estimation(HIGHWAY_PATH, HIGHWAY_SEQ, meanP, varP);   
    
end

