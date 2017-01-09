function [  ] = task3(dataset_path)
    tic
    %HIGHWAY SEQUENCE EXPERIMENT
    SEQ = [1050, 1350];
    PATH = strcat(dataset_path, 'dataset/baseline/highway/');

    % FALL SEQUENCE EXPERIMENT
    %     SEQ = [1460, 1560];
    %     PATH = strcat(dataset_path, 'dataset/dynamicBackground/fall/');

    % TRAFFIC SEQUENCE EXPERIMENT
    % SEQ = [950, 1050];
    % PATH = strcat(dataset_path, 'dataset/cameraJitter/traffic/');


    precisionList=[];
    recallList=[];
    f1List = [];
    learningRateList=[];
    minimumBackgroundRatioList=[];
    numGaussiansList = [];
    for learningRate=0.001:0.1:1
        for minimumBackgroundRatio=0.000:0.1:1
            for numGaussians=3:6

                detector = vision.ForegroundDetector('NumGaussians', numGaussians, ...
                    'LearningRate', learningRate, ...
                    'MinimumBackgroundRatio', minimumBackgroundRatio);
                videoPlayer = vision.VideoPlayer();

                IN_PATH = strcat(PATH, 'input/');
                GT_PATH = strcat(PATH, 'groundtruth/');
                first = SEQ(1);
                last = SEQ(2);

                TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
                for i = first : last
                    frame = im2double(rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) ));
                    fgMask = step(detector, frame);
                    % step(videoPlayer, fgMask);
                    gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png')) ;
                    [TP, FP, FN, TN] = performance_pixel(fgMask, gt);
                    TPaccum = TPaccum+TP;
                    FPaccum = FPaccum + FP;
                    FNaccum = FNaccum + FN;
                    TNaccum = TNaccum + TN;
                end
                [prec, rec, f1score] = performance_metrics(TPaccum, FPaccum, FNaccum);
                precisionList=[precisionList prec];
                recallList=[recallList rec];
                f1List = [f1List f1score];
                learningRateList=[learningRateList learningRate];
                minimumBackgroundRatioList=[minimumBackgroundRatioList minimumBackgroundRatio];
                numGaussiansList = [numGaussiansList numGaussians];
            end
        end
    end

    [maxF1, index] = max(f1List);
    disp(sprintf('Best configuration:\n Precision %f\n Recall %f\n F1 %f\n learningRate %f\n minimumBackgroundRatio %f\n numGaussians %f\n',precisionList(index), recallList(index),f1List(index),learningRateList(index),minimumBackgroundRatioList(index),numGaussiansList(index)));
    plot(recallList, precisionList);
    title(strcat('Precision Recall'));
    xlabel('Recall');
    ylabel('Precision');
    AUC = trapz(precisionList)
    toc;
end

