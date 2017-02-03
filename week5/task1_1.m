function [ output_args ] = task1_1( input_args )
%TASK1_1 Summary of this function goes here
%   Detailed explanation goes here
    seq_path = '../dataset2014/dataset/baseline/highway/input/';
    seq_traffic = [1050, 1350];
    
    [meanP, varP] = background_modeling(PATH, seq_traffic, n_samples, false);
    
    for i = seq_traffic(1) : seq_traffic(2)
       frame = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')) );
       imshow(frame);
       pause(0.0001);
    end

end

