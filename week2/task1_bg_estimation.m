function [TPaccum, FPaccum, FNaccum, TNaccum, prec, rec] = task1_bg_estimation(PATH, sequence, meanP, varP, n_samples, alpha)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    IN_PATH = strcat(PATH, 'input/');
    GT_PATH = strcat(PATH, 'groundtruth/');
        
    first = sequence(1) + n_samples + 1;
    last = sequence(2);
    
    TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
    for i = first : last
        in = rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
        gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png'));
        in = im2double(in);
        
        foreground = zeros(size(in, 1), size(in, 2));
        foreground = abs(in - meanP) >= (alpha * (varP + 2.0));
        
        [TP, FP, FN, TN] = performance_results(foreground, gt);
        
        TPaccum = TPaccum + TP;
        FPaccum = FPaccum + FP;
        FNaccum = FNaccum + FN;
        TNaccum = TNaccum + TN;
        
        %plot_estimation(foreground, in);
    end
%     if TP == 0 || FP == 0 || FN == 0
%         TP
%     end
    [prec, rec] = performance_metrics_prec_rec(TPaccum, FPaccum, FNaccum);
end

function [prec, rec] = performance_metrics_prec_rec(TP, FP, FN)
    prec = TP / (TP + FP);
    rec = TP / (TP + FN);   
end

function [] = plot_estimation(foreground, in)
    subplot(1, 2, 1);
    imshow(in);
    subplot(1, 2, 2);
    imshow(foreground);
    pause(0.0001)
end

