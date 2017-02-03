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
    j=1;
    while hasFrame(shuttleVideo)
       img = readFrame(shuttleVideo);
       filename = ['in00' sprintf('%04d',j) '.jpg'];
       fullname = fullfile(workingDir,'images',filename);
       %img = imcrop(img,[436,342,1041, 738]); GOPRO
       img = imresize(img(425:1080,410:1528,:),0.5);
%        imshow(img)
%       
%        pause(0.0000001)
       if ii>15 && (ii<1415 || ii>1740)
           imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
           j = j+1;
       end
       ii = ii+1;
    end
end

