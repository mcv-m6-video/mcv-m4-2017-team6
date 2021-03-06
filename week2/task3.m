function [  ] = task3(dataset_path)
    tic
    for x=1:3
        %HIGHWAY SEQUENCE EXPERIMENT
        if x==1
            SEQ = [1050, 1350];
            PATH = strcat(dataset_path, 'dataset/baseline/highway/');
            name = 'Highway';
            numGaussians=3;
        elseif x==2
            % FALL SEQUENCE EXPERIMENT
            SEQ = [1460, 1560];
            PATH = strcat(dataset_path, 'dataset/dynamicBackground/fall/');
            name = 'Fall';
            numGaussians=3;
        elseif x==3
            % TRAFFIC SEQUENCE EXPERIMENT
            SEQ = [950, 1050];
            PATH = strcat(dataset_path, 'dataset/cameraJitter/traffic/');
            name = 'Traffic';
            numGaussians=4;
        end
        precisionList=[];
        recallList=[];
        f1List = [];
        learningRateList=[];
        minimumBackgroundRatioList=[];
        numGaussiansList = [];
        for learningRate=0.001:0.1:0.001
            for minimumBackgroundRatio=0:0.1:1
                %for numGaussians=4:4

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
                %end
            end
        end
        plots{x,1}=recallList;
        plots{x,2}= precisionList;
        precisionList(isnan(precisionList)) = 0 ;
        AUC(x) = abs(trapz(recallList,precisionList));
    end
    fig=subplot(1,1,1)
    hold on;
    [maxF1, index] = max(f1List);
    for x=1:3
        plot(plots{x,1},plots{x,2})
    end
   % disp(sprintf('Best configuration:\n Precision %f\n Recall %f\n F1 %f\n learningRate %f\n minimumBackgroundRatio %f\n numGaussians %f\n',precisionList(index), recallList(index),f1List(index),learningRateList(index),minimumBackgroundRatioList(index),numGaussiansList(index)));
    % plot(recallList, precisionList);
    title(strcat('Precision Recall'));
    legend(fig,strcat('Highway - AUC ', num2str(AUC(1))),strcat('Fall - AUC ', num2str(AUC(2))),strcat('Traffic - AUC ', num2str(AUC(3))))
    xlabel('Recall');
    ylabel('Precision');
%     precisionList(isnan(precisionList)) = 0 ;
%     AUC = abs(trapz(recallList,precisionList))
    toc;
end

