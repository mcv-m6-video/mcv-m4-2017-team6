function [ output_args ] = task2_2( dataset_path )
PATH = strcat(dataset_path, 'dataset/cameraJitter/traffic/');
SEQ = [950, 1050];
imgA = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',SEQ(1)), '.jpg')) ));
images(SEQ(1),:,:)=imgA;
imagesGT(SEQ(1),:,:)=imread(strcat(PATH,'groundtruth/', 'gt00', sprintf('%04d',SEQ(1)), '.png')) ;
imgB = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',SEQ(1)+1), '.jpg')) ));
for i = SEQ(1): SEQ(2)-1
    i
    if i>SEQ(1)
        imgA= images(i,:,:);
        imgA = squeeze(imgA);
        imgB = im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',i+1), '.jpg')) ));
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
    
    imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
    imgBsRt  = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));
    images(i+1,:,:)=imgBsRt;
    imGT=imread(strcat(PATH,'groundtruth/', 'gt00', sprintf('%04d',i+1), '.png')) ;
    imagesGT(i+1,:,:)=imwarp(imGT, tformsRT, 'OutputView', imref2d(size(imGT)));
    % figure(2), clf;
    % imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
    % title('Color composite of affine and s-R-t transform outputs');
end
mkdir('matlabStabilization/input');
mkdir('matlabStabilization/groundtruth');
outputVideo = VideoWriter(fullfile('matlabStabilization/video.avi'));
open(outputVideo);

for ii = SEQ(1): SEQ(2)
   imgA= images(ii,:,:);
   imgA = squeeze(imgA);
   imgGT= imagesGT(ii,:,:);
   imgGT = squeeze(imgGT);
   imwrite(imgA,strcat('matlabStabilization/input/','in00', sprintf('%04d',ii), '.jpg'));
   imwrite(imgGT,strcat('matlabStabilization/groundtruth/','gt00', sprintf('%04d',ii), '.png'));
   writeVideo(outputVideo,[imgA im2double(rgb2gray( imread(strcat(PATH,'/input/', 'in00', sprintf('%04d',ii), '.jpg')) ))]);
end
close(outputVideo)
end
% count = 0;
% err_count = 0;
% while count == err_count
% try
% task2_2('C:/Users/arnau/Desktop/')
% catch MyErr
% err_count = err_count + 1;
% end
% count = count + 1;
% end
