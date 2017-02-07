function [ output_args ] = avi_to_gif( input_args )
%AVI_TO_GIF Summary of this function goes here
%   Detailed explanation goes here

    v = VideoReader('gifs/uab_frames.avi');
    filename = 'gifs/uab_frames.gif';
    k = 1;
    while hasFrame(v)
        [frame, cm] = rgb2ind(readFrame(v), 256);
        if k == 1
            imwrite(frame,cm,filename,'gif','LoopCount',Inf,'DelayTime',0);
        else
            imwrite(frame,cm,filename,'gif','WriteMode','append','DelayTime',0);
        end
        k = k+1;
    end
end