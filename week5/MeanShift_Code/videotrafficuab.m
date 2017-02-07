SEQ=[1 1716]
mkdir('trafficUAB/video');
outputVideo = VideoWriter(fullfile('trafficUAB/video/video.avi'));
open(outputVideo);
for ii = SEQ(1): SEQ(2)
    writeVideo(outputVideo, im2double(imread(strcat('C:/Users/abaro/Documents/master/m4/mcv-m4-2017-team6/week5/trafficUAB/images/', 'in00', sprintf('%04d',ii), '.jpg'))));
end
close(outputVideo)