function [ ] = display_sequences( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    ori_path = 'traffic_corrected/original/';
    corr_path = 'traffic_corrected/';
    seq_traffic = [950, 1050];

    
    for i = seq_traffic(1) : seq_traffic(2)-1
        ori = imread(strcat(ori_path, 'in00', sprintf('%04d',i), '.jpg'));
        corr = imread(strcat(corr_path, 'in00', sprintf('%04d',i), '.jpg'));
        i
        subplot(1,2,1), subimage(ori), title('Original')
        subplot(1,2,2), subimage(corr), title('Motion compensation')
        pause(0.001);
    end
    
    

end

