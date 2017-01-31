function [ output_args ] = create_gif( input_args )
%CREATE_GIF Summary of this function goes here
%   Detailed explanation goes here

    %seq_path = '../dataset2014/dataset/cameraJitter/traffic/input/';
    seq_path = 'gt_corrected/';
    
    filename = 'gifs/gt_corrected.gif'; % Specify the output file name

    seq_traffic = [950, 1050];
    first = imread(strcat(seq_path, 'gt00', sprintf('%04d',950), '.png'));
    if length(size(first)) == 3
        first = rgb2gray( first );
    end
    
    
    imwrite(first,filename,'gif','LoopCount',Inf,'DelayTime',0);
    
    for i = seq_traffic(1)+1 : seq_traffic(2)
        im = imread(strcat(seq_path, 'gt00', sprintf('%04d',i), '.png'));
        
        if length(size(im)) == 3
            im = rgb2gray( im );
        end
        
        imwrite(im,filename,'gif','WriteMode','append','DelayTime',0);
    end
    
end

