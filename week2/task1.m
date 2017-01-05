function [ ] = task1(dataset_path, option)
%UNTITLED Summary of this function goes here
%   Params:
%       option: values -> 'GRID_SEARCH' or 'ALPHA_SEARCH'

    dataset_path = strcat(dataset_path, 'dataset/');
    
    INTERVALS = 10;
    ADAPTATIVE = true;
    RHO = 0.5; % Setting RHO = 0 is the same as using non-adaptative
    OPT = option;
    COLOR = true;
    
    % HIGHWAY SEQUENCE EXPERIMENT
    HIGHWAY_SEQ = [1050, 1350];
    HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
    disp('##### HIGHWAY SEQUENCE EXPERIMENT #####')
    task1_bg_experiment(HIGHWAY_SEQ, HIGHWAY_PATH, 'HIGHWAY', INTERVALS, RHO, ADAPTATIVE, OPT, COLOR);
    
    % FALL SEQUENCE EXPERIMENT
%     FALL_SEQ = [1460, 1560];
%     FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
%     disp('##### FALL SEQUENCE EXPERIMENT #####')
%     task1_bg_experiment(FALL_SEQ, FALL_PATH, 'FALL', INTERVALS, RHO, ADAPTATIVE, OPT);
    
    % TRAFFIC SEQUENCE EXPERIMENT
%     TRAFFIC_SEQ = [950, 1050];
%     TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
%     disp('##### TRAFFIC SEQUENCE EXPERIMENT #####')
%     task1_bg_experiment(TRAFFIC_SEQ, TRAFFIC_PATH, 'TRAFFIC', INTERVALS, RHO, ADAPTATIVE, OPT);

end

