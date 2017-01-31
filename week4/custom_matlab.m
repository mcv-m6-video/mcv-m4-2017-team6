function [ output_args ] = custom_matlab( dataset_path )
%CUSTOM_MATLAB Summary of this function goes here
%   Detailed explanation goes here
PATH = strcat(dataset_path, 'custom_video/frames/');
SEQ = [1, 192];
imgA = im2double(rgb2gray( imread(strcat(PATH, 'in00', sprintf('%04d',SEQ(1)), '.jpg')) ));
images(SEQ(1),:,:)=imgA;
images2(SEQ(1),:,:,:)= im2double(( imread(strcat(PATH, 'in00', sprintf('%04d',SEQ(1)), '.jpg')) ));
imgB = im2double(rgb2gray( imread(strcat(PATH,'in00', sprintf('%04d',SEQ(1)+1), '.jpg')) ));
for i = SEQ(1): SEQ(2)-1
    i
    if i>SEQ(1)
        imgA= images(i,:,:);
        imgA = squeeze(imgA);
        imgB = im2double(rgb2gray( imread(strcat(PATH,'in00', sprintf('%04d',i+1), '.jpg')) ));
    end
    %         figure; imshowpair(imgA,imgB,'ColorChannels','red-cyan');
    %         title('Color composite (frame A = red, frame B = cyan)');
    ptThresh = 0.02;
    pointsA = detectSURFFeatures(imgA,'MetricThreshold',400);
    pointsB = detectSURFFeatures(imgB,'MetricThreshold',400);
    % Display corners found in images A and B.
    % figure; imshow(imgA); hold on;
    % plot(pointsA);
    % title('Corners in A');
    %
    % figure; imshow(imgB); hold on;
    % plot(pointsB);
    % title('Corners in B');
    [featuresA, pointsA] = extractFeatures(imgA, pointsA);
    [featuresB, pointsB] = extractFeatures(imgB, pointsB);
    % Extract FREAK descriptors for the corners
    [featuresA, pointsA] = extractFeatures(imgA, pointsA);
    [featuresB, pointsB] = extractFeatures(imgB, pointsB);
    indexPairs = matchFeatures(featuresA, featuresB);
    
    pointsA = pointsA(indexPairs(:, 1), :);
    pointsB = pointsB(indexPairs(:, 2), :);
    %         figure; showMatchedFeatures(imgA, imgB, pointsA, pointsB);
    % legend('A', 'B');
    [tform, pointsBm, pointsAm] = estimateGeometricTransform(...
        pointsB, pointsA, 'affine');
    imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
    pointsBmp = transformPointsForward(tform, pointsBm.Location);
    % figure;
    % showMatchedFeatures(imgA, imgBp, pointsAm, pointsBmp);
    % legend('A', 'B');
    % Extract scale and rotation part sub-matrix.
    H = tform.T;
    R = H(1:2,1:2);
    % Compute theta from mean of two possible arctangents
    theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
    % Compute scale from mean of two stable mean calculations
    scale = mean(R([1 4])/cos(theta));
    % Translation remains the same:
    translation = H(3, 1:2);
    
    % Reconstitute new s-R-t transform:
    HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
        translation], [0 0 1]'];
    tformsRT = affine2d(HsRt);
    
    
    imgBsRt  = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));
    images(i+1,:,:)=imgBsRt;
    im2=im2double(( imread(strcat(PATH, 'in00', sprintf('%04d',i+1), '.jpg')) ));
    images2(i+1,:,:,:)=imwarp(im2, tformsRT, 'OutputView', imref2d(size(im2)));
    % figure(2), clf;
    % imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
    % title('Color composite of affine and s-R-t transform outputs');
end
mkdir(strcat(dataset_path,'custom_video/matlab_function'));
outputVideo = VideoWriter(fullfile('custom_video/matlab_function/video_custom_matlab.avi'));
open(outputVideo);

for ii = SEQ(1): SEQ(2)
   imgA= images2(ii,:,:,:);
   imgA = squeeze(imgA);
   imwrite(imgA,strcat('custom_video/matlab_function/','in00', sprintf('%04d',ii), '.jpg'));
   writeVideo(outputVideo,imgA);
end
close(outputVideo)
end

