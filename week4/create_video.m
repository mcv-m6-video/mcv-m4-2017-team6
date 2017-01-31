function [ output_args ] = create_video( input_args )
%CREATE_VIDEO Summary of this function goes here
%   Detailed explanation goes here

outputVideo = VideoWriter(fullfile('custom_video/stabilized.avi'));
open(outputVideo);

seq_path = 'custom_video/stabilized/';
seq = [1, 165];

for i = seq(1): seq(2)
   writeVideo(outputVideo,[imread(strcat(seq_path,'in00', sprintf('%04d',i), '.jpg')) ]);
end
close(outputVideo)

end

