function [ output_args ] = task2_2( dataset_path )
PATH = strcat(dataset_path, 'dataset/cameraJitter/traffic/');
SEQ = [950, 1050];
imgA = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',SEQ(1)), '.jpg')) ));
imgB = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',SEQ(1)+1), '.jpg')) ));
for i = SEQ(1): SEQ(2)-1
    i
    if i>SEQ(1)
        imgA= images(i-1,:,:);
        imgA = squeeze(imgA);
        imgB = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',i+1), '.jpg')) ));
    end
    %         figure; imshowpair(imgA,imgB,'ColorChannels','red-cyan');
    %         title('Color composite (frame A = red, frame B = cyan)');
    ptThresh = 0.02;
    pointsA = detectSURFFeatures(imgA,'MetricThreshold',500);
    pointsB = detectSURFFeatures(imgB,'MetricThreshold',500);
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
    
    imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
    imgBold = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));
    images(i,:,:)=imgBold;
    
    % figure(2), clf;
    % imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
    % title('Color composite of affine and s-R-t transform outputs');
end
outputVideo = VideoWriter(fullfile(dataset_path,'video.avi'));
open(outputVideo);
for ii = SEQ(1): SEQ(2)-1
   imgA= images(ii-1,:,:);
   imgA = squeeze(imgA);
   writeVideo(outputVideo,[imgA im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',ii), '.jpg')) ))]);
end
close(outputVideo)
end

