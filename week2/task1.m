function [ ] = task1(dataset_path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dataset_path = strcat(dataset_path, 'dataset/');

    % HIGHWAY SEQUENCE EXPERIMENT
    HIGHWAY_SEQ = [1050, 1350];
    HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
    disp('##### HIGHWAY SEQUENCE EXPERIMENT #####')
    task1_bg_segmentation(HIGHWAY_SEQ, HIGHWAY_PATH, 'HIGHWAY');
    
    % FALL SEQUENCE EXPERIMENT
    FALL_SEQ = [1460, 1560];
    FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
    disp('##### FALL SEQUENCE EXPERIMENT #####')
    task1_bg_segmentation(FALL_SEQ, FALL_PATH, 'FALL');
    
    % TRAFFIC SEQUENCE EXPERIMENT
    TRAFFIC_SEQ = [950, 1050];
    TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
    disp('##### TRAFFIC SEQUENCE EXPERIMENT #####')
    task1_bg_segmentation(TRAFFIC_SEQ, TRAFFIC_PATH, 'TRAFFIC');
    
end

