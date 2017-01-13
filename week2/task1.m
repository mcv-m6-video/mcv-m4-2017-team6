function [ ] = task1(dataset_path)
%UNTITLED Summary of this function goes here
%   Params:
%       option: values -> 'GRID_SEARCH' or 'ALPHA_SEARCH'

    dataset_path = strcat(dataset_path, 'dataset/');
    
    INTERVALS = 20;
    ADAPTATIVE = false;
    RHO = 0; % Setting RHO = 0 is the same as using non-adaptative
    OPT = 'ALPHA_SEARCH';
    COLOR = false;
    
    % HIGHWAY SEQUENCE EXPERIMENT
%     HIGHWAY_SEQ = [1050, 1350];
%     HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
%     disp('##### HIGHWAY SEQUENCE EXPERIMENT #####')
%     task1_bg_experiment(HIGHWAY_SEQ, HIGHWAY_PATH, 'HIGHWAY', INTERVALS, RHO, ADAPTATIVE, OPT, COLOR);
    
    % FALL SEQUENCE EXPERIMENT
    FALL_SEQ = [1460, 1560];
    FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
    disp('##### FALL SEQUENCE EXPERIMENT #####')
    task1_bg_experiment(FALL_SEQ, FALL_PATH, 'FALL', INTERVALS, RHO, ADAPTATIVE, OPT, COLOR);
    
    % TRAFFIC SEQUENCE EXPERIMENT
%     TRAFFIC_SEQ = [950, 1050];
%     TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
%     disp('##### TRAFFIC SEQUENCE EXPERIMENT #####')
%     task1_bg_experiment(TRAFFIC_SEQ, TRAFFIC_PATH, 'TRAFFIC', INTERVALS, RHO, ADAPTATIVE, OPT, COLOR);

end

