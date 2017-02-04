function [ output_args ] = task1_1( input_args )
%TASK1_1 Summary of this function goes here
%   Detailed explanation goes here

    % HIGHWAY
    seq_path = '../dataset2014/dataset/baseline/highway/input/';
    SEQ = [1050, 1350];
    TRACK_SEQ = [1, 1700];
    
    % TRAFFIC
%     seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
%     SEQ = [950, 1050];
%     TRACK_SEQ = [1, 1570];
    
    % TRAFFIC STABILIZED
%     seq_path = '../week4/traffic_dataset/input/';
%     %SEQ = [950, 1050];
%     SEQ = [950, 1050];
%     TRACK_SEQ = [1, 1570];
%     %TRACK_SEQ = SEQ;

    % UAB
    seq_path = 'trafficUAB/images/';
    SEQ = [1, 300];
    TRACK_SEQ = [1, 1716];
    
    % We start by modeling the background
    model = {};
    model.modeling_ratio = 0.5;
    model.color = false;
    model.SEQ = SEQ;
    model.TRACK_SEQ = TRACK_SEQ;
    model.ignoreblack = 1;
    
    n_samples = int32( (SEQ(2) - SEQ(1)) * model.modeling_ratio );
    [meanP, varP] = background_modeling(seq_path, SEQ, n_samples, model.color);
    
    model.meanP = meanP;
    model.varP = varP;
    
    % parameters for foreground detection
    model.alpha = 2.5; %3; %3.75;
    model.rho = 0.05; % 0.1; % 0.15;
    %model.rho = 0.10; % FOR UAB
    model.opening = 30; % 1000
    model.morpho = true;
    model.se = strel('square',3);
    model.adaptative = true;
    model.shadow = false;
    model.filling = true;
    model.connectivity = 4;
    
    multipleTrack(seq_path, model);
end

