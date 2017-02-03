function [ ] = task2_1( generate_gt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
    %seq_traffic = [950, 1050];
    seq_traffic = [1, 1570];
    
    block_size = 16; % Typically 16x16 pixels
    area_of_search = 16; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'bwd'; % options 'fwd' or 'bwd'
    
    udir_accum = 0;
    vdir_accum = 0;
    cropsize = 20;
    firstC = imread(strcat(seq_path, 'in000001.jpg'));
    first = rgb2gray(firstC);
    imwrite(firstC(cropsize:end-cropsize,cropsize:end-cropsize, :),strcat('traffic_dataset/input/', 'in000001.jpg'));
    if generate_gt
        gt = imread('../dataset2014/dataset/cameraJitter/traffic/groundtruth/gt000001.png');
        imwrite(gt(cropsize:end-cropsize,cropsize:end-cropsize), 'traffic_dataset/groundtruth/gt000001.png');
    end
    
    for i = seq_traffic(1) : seq_traffic(2)-1
        i
        pastC = imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')); 
        past = rgb2gray(pastC);
        currC = imread(strcat(seq_path, 'in00', sprintf('%04d',i+1), '.jpg'));
        curr = rgb2gray(currC);
        flow_result = optical_flow(past, curr, block_size, area_of_search, compensation, 0);
        
        [udir_accum,vdir_accum]=motion_compensation(flow_result(:,:,2), flow_result(:,:,1), udir_accum, vdir_accum);
        
        corrected = imtranslate(currC, [udir_accum, vdir_accum]);
        imwrite(corrected(cropsize:end-cropsize,cropsize:end-cropsize, :), strcat('traffic_dataset/input/', 'in00', sprintf('%04d',i+1), '.jpg'));
        
        if generate_gt
            gt = imread(strcat('../dataset2014/dataset/cameraJitter/traffic/groundtruth/', 'gt00', sprintf('%04d',i+1), '.png'));
            gt_corrected = imtranslate(gt, [udir_accum, vdir_accum]);
            imwrite(gt_corrected(cropsize:end-cropsize,cropsize:end-cropsize), strcat('traffic_dataset/groundtruth/', 'gt00', sprintf('%04d',i+1), '.png'));
        end
        
    end


    
    
    
    
    

end

