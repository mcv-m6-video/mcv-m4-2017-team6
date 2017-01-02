function [ output_args ] = task3(dataset_path, numGaussians )

% HIGHWAY SEQUENCE EXPERIMENT
SEQ = [1050, 1350];
PATH = strcat(dataset_path, 'dataset/baseline/highway/');

% FALL SEQUENCE EXPERIMENT
%     SEQ = [1460, 1560];
%     PATH = strcat(dataset_path, 'dataset/dynamicBackground/fall/');

% TRAFFIC SEQUENCE EXPERIMENT
%     SEQ = [950, 1050];
%     PATH = strcat(dataset_path, 'dataset/cameraJitter/traffic/');


detector = vision.ForegroundDetector(...
    'NumTrainingFrames', floor((SEQ(2)-SEQ(1))/2), ...
    'NumGaussians', numGaussians);



videoPlayer = vision.VideoPlayer();


IN_PATH = strcat(PATH, 'input/');
GT_PATH = strcat(PATH, 'groundtruth/');
first = SEQ(1);
last = SEQ(2);

TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
for i = first : last
    frame = rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
    fgMask = step(detector, frame);
    step(videoPlayer, fgMask);
    gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png')) ;
    [TP, FP, FN, TN] = performance_pixel(fgMask, gt);
    TPaccum = TPaccum+TP;
    FPaccum = FPaccum + FP;
    FNaccum = FNaccum + FN;
    TNaccum = TNaccum + TN;
end
[prec, rec, f1score] = performance_metrics(TPaccum, FPaccum, FNaccum)
release(videoPlayer);

end

