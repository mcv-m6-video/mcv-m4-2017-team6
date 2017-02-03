function [ ] = display_sequences( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    ori_path = 'traffic_dataset/input/original/';
    corr_path = 'traffic_dataset/input/';
    seq_traffic = [1001, 1050];
    
    outputVideo = VideoWriter('traffic_dataset/1_motion_compensation.avi');
    outputVideo.FrameRate = 20;
    open(outputVideo);
    
    for i = seq_traffic(1) : seq_traffic(2)-1
        ori = imread(strcat(ori_path, 'in00', sprintf('%04d',i), '.jpg'));
        corr = imread(strcat(corr_path, 'in00', sprintf('%04d',i), '.jpg'));
        ori_seg = imread(strcat('foreground_results/original/', 'in00', sprintf('%04d',i), '.png'));
        corr_seg = imread(strcat('foreground_results/compensated/', 'in00', sprintf('%04d',i), '.png'));
        ori = ori(20:end-20, 20:end-20);
        ori_seg = ori_seg(20:end-20, 20:end-20);
        ori_seg = ori_seg * 255;
        corr_seg = corr_seg * 255;
        double_i = [ori, corr; ori_seg, corr_seg];
        imshow(double_i);
        
        F = getframe;
        writeVideo(outputVideo, F);
        pause(0.001);
    end
    
    

end

