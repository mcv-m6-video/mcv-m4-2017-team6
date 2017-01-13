function [] = task2( dataset_path )
%TASK2 Summary of this function goes here
%   Detailed explanation goes here

    dataset_path = strcat(dataset_path, 'dataset/');
    INTERVALS = 5;
    ADAPTATIVE = true;
    OPT = 'fixed';
    COLOR = false;
    FILLING = true;
    
    % HIGHWAY SEQUENCE EXPERIMENT
    RHO_HIGHWAY = 0.25; % Setting RHO = 0 is the same as using non-adaptative
    ALPHA_HIGHWAY = 3.75;
    HIGHWAY_SEQ = [1050, 1350];
    HIGHWAY_PATH = strcat(dataset_path, 'baseline/highway/');
    disp('##### HIGHWAY SEQUENCE EXPERIMENT 4 CONNECTIVITY FILLING #####')
    bg_experiment(HIGHWAY_SEQ, HIGHWAY_PATH, 'HIGHWAY', INTERVALS, ALPHA_HIGHWAY, RHO_HIGHWAY, ADAPTATIVE, OPT, COLOR, 4, FILLING);
    
    % FALL SEQUENCE EXPERIMENT
%     RHO_FALL = 0.052632; % Setting RHO = 0 is the same as using non-adaptative
%     ALPHA_FALL = 3.157895;
%     FALL_SEQ = [1460, 1560];
%     FALL_PATH = strcat(dataset_path, 'dynamicBackground/fall/');
%     disp('##### FALL SEQUENCE EXPERIMENT 4 CONNECTIVITY FILLING #####')
%     bg_experiment(FALL_SEQ, FALL_PATH, 'FALL', INTERVALS, ALPHA_FALL, RHO_FALL, ADAPTATIVE, OPT, COLOR, 4, FILLING);


    % TRAFFIC SEQUENCE EXPERIMENT
%     RHO_TRAFFIC = 0.157895; % Setting RHO = 0 is the same as using non-adaptative
%     ALPHA_TRAFFIC = 3.421053;
%     TRAFFIC_SEQ = [950, 1050];
%     TRAFFIC_PATH = strcat(dataset_path, 'cameraJitter/traffic/');
%     disp('##### TRAFFIC SEQUENCE EXPERIMENT 4 CONNECTIVITY FILLING #####')
%     bg_experiment(TRAFFIC_SEQ, TRAFFIC_PATH, 'TRAFFIC', INTERVALS, ALPHA_TRAFFIC, RHO_TRAFFIC, ADAPTATIVE, OPT, COLOR, 4, FILLING);



end

