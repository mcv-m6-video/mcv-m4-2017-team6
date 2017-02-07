function [ output_args ] = task1_1( input_args )
%TASK1_1 Summary of this function goes here
%   Detailed explanation goes here

    model = {};
    
    run = 'HIGHWAY';
    switch run
        case 'HIGHWAY'
            % HIGHWAY
            model.seq_path = '../dataset2014/dataset/baseline/highway/input/';
            model.SEQ = [1050, 1350];
            model.TRACK_SEQ = [1, 1700];
            model.aux = [219 1; 275 1; 1 204; 254 204];
            model.pix_metr = 0.5;
            model.fps = 30.0;
            model.save_gif = 'gifs/highway';
        case 'TRAFFIC'
            % TRAFFIC
            model.seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
            model.SEQ = [1, 1570];
            model.TRACK_SEQ = [1, 1570];
            % TRAFFIC STABILIZED
%             model.seq_path = '../week4/traffic_dataset/input/';
%             SEQ = [950, 1050];
%             model.SEQ = [1, 1570];
%             model.TRACK_SEQ = [1, 1570];
            model.aux = [246 1; 342 1; 68 328; 499 328]; % NOT THE REAL ONE
            model.pix_metr = 0.109649; % NOT THE REAL ONE
            model.fps = 30.0; % NOT THE REAL ONE
            model.save_gif = 'gifs/traffic';
        case 'UAB'
            % UAB
            model.seq_path = 'trafficUAB/images/';
            model.SEQ = [1, 300];
            model.TRACK_SEQ = [1, 1716];
            model.aux = [246 1; 342 1; 68 328; 499 328];
            model.pix_metr = 0.109649;
            model.fps = 30.0;
            model.save_gif = 'gifs/uab';
    end
        
    % We start by modeling the background
    model.modeling_ratio = 0.5;
    model.color = false;
    model.ignoreblack = 1;
    
    n_samples = int32( (model.SEQ(2) - model.SEQ(1)) * model.modeling_ratio );
    [meanP, varP] = background_modeling(model.seq_path, model.SEQ, n_samples, model.color);
    
    model.meanP = meanP;
    model.varP = varP;
    
    % parameters for foreground detection
    model.alpha = 3.75; %3; %3.75;
    model.rho = 0.1; % 0.1; % 0.15;
    %model.rho = 0.10; % FOR UAB
    model.opening = 10; % 1000
    model.morpho = true;
    model.se = strel('square',3);
    model.adaptative = true;
    model.shadow = false;
    model.filling = true;
    model.connectivity = 4;
    
    multipleTrack(model);
end

