function [ output_args ] = custom_video( input_args )
%CUSTOM_VIDEO Summary of this function goes here
%   Detailed explanation goes here

    % FIRST READ VIDEO
    video = VideoReader('custom_video/custom.mp4');
    i = 1;
    filename = 'custom_video/original.gif';
    while hasFrame(video)
       frame = readFrame(video);
       frame = imresize(frame, 0.25);
       
       [frame_ind,cm] = rgb2ind(frame,256);
       if i == 1
          imwrite(frame_ind,cm,filename,'gif','LoopCount',Inf,'DelayTime',0);
       else
           imwrite(frame_ind,cm,filename,'gif','WriteMode','append','DelayTime',0);
       end
       
       imwrite(frame,strcat('custom_video/frames/', 'in00', sprintf('%04d',i), '.jpg'));
       i = i+1;
    end
    
    % NOW PERFORM MOTION COMPENSATION
    seq_path = 'custom_video/frames/';
    seq = [1, i-1];
    
    block_size = 16; % Typically 16x16 pixels
    area_of_search = 16; % P pixels in every direction: (2P+N)x(2P+N) pixels. Typically P = N
    compensation = 'bwd'; % options 'fwd' or 'bwd'
    
    udir_accum = 0;
    vdir_accum = 0;
    
    first = imread(strcat(seq_path, 'in00', sprintf('%04d',seq(1)), '.jpg'));
    imwrite(first,strcat('custom_video/stabilized/', 'in00', sprintf('%04d',seq(1)), '.jpg'));
    filename = 'custom_video/stabilized.gif';
    for i = seq(1) : seq(2)-1
        i
        curr_color = imread(strcat(seq_path, 'in00', sprintf('%04d',i+1), '.jpg'));
        past = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')) );
        curr = rgb2gray( curr_color );
        flow_result = optical_flow(past, curr, block_size, area_of_search, compensation, 0);
        
        %[udir_accum,vdir_accum]=motion_compensation(u, v, udir_accum, vdir_accum);
        [udir_accum,vdir_accum]=motion_compensation(flow_result(:,:,2), flow_result(:,:,1), udir_accum, vdir_accum);
        
        corrected = imtranslate(curr_color, [udir_accum, vdir_accum]);
        
        [frame_ind,cm] = rgb2ind(corrected,256);
        if i == seq(1)
          imwrite(frame_ind,cm,filename,'gif','LoopCount',Inf,'DelayTime',0);
        else
           imwrite(frame_ind,cm,filename,'gif','WriteMode','append','DelayTime',0);
        end
        
        imwrite(corrected, strcat('custom_video/stabilized/', 'in00', sprintf('%04d',i+1), '.jpg'));
        
    end
    
end

