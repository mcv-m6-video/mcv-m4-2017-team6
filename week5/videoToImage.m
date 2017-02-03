function videoToImage( videoPath )


    str_parts = strsplit(videoPath,'/');
    sz=size(str_parts,2);
    video_name=cell2mat(str_parts(sz));
    str_parts2 = strsplit(video_name,'.');
    workingDir = cell2mat(str_parts2(1));
    mkdir(workingDir);
    mkdir(workingDir,'images');
    shuttleVideo = VideoReader(videoPath);

    ii = 1;

    while hasFrame(shuttleVideo)
       img = readFrame(shuttleVideo);
       filename = [sprintf('%03d',ii) '.jpg'];
       fullname = fullfile(workingDir,'images',filename);
       img = imcrop(img,[440,328,600, 400]);
       imshow(img)
       
       waitforbuttonpress
        waitforbuttonpress
         waitforbuttonpress
          waitforbuttonpress
       %imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
       ii = ii+1;
    end
end

