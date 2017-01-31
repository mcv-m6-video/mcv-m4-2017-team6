function [ ] = display_sequences( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    ori_path = 'traffic_dataset/input/original/';
    corr_path = 'traffic_dataset/input/';
    seq_traffic = [950, 1050];
    
    outputVideo = VideoWriter('traffic_dataset/1_motion_compensation.avi');
    outputVideo.FrameRate = 20;
    open(outputVideo);
    
    for i = seq_traffic(1) : seq_traffic(2)-1
        ori = imread(strcat(ori_path, 'in00', sprintf('%04d',i), '.jpg'));
        corr = imread(strcat(corr_path, 'in00', sprintf('%04d',i), '.jpg'));
        ori = ori(20:end-20, 20:end-20);
        corr = corr(20:end-20, 20:end-20);
        double_i = [ori,corr];
        imshow(double_i);
        
        F = getframe;
        writeVideo(outputVideo, F);
        pause(0.001);
    end
    
    

end

