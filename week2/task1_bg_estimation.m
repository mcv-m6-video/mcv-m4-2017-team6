function [TPaccum, FPaccum, FNaccum, TNaccum] = task1_bg_estimation(PATH, sequence, meanP, varP, n_samples, alpha)
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
end

function [TP, FP, FN, TN] = performance_results(pixelCandidates, gt)
    %fg = foreground;
    %bg = ~foreground;
    
    pixelGt = gt==255;
    %gt_bg = gt <= 50;
    gt_eval1 = gt == 85;
    gt_eval2 = gt == 170;
    gt_eval = ~(gt_eval1 + gt_eval2);
    
    TP_mat = pixelCandidates>0 & pixelGt>0;
    FP_mat = pixelCandidates>0 & pixelGt==0;
    FN_mat = pixelCandidates==0 & pixelGt>0;
    TN_mat = pixelCandidates==0 & pixelGt==0;
    
    TP = sum(sum( TP_mat(gt_eval) ));
    FP = sum(sum( FP_mat(gt_eval) ));
    FN = sum(sum( FN_mat(gt_eval) ));
    TN = sum(sum( TN_mat(gt_eval) ));
    
end

function [] = plot_estimation(foreground, in)
    subplot(1, 2, 1);
    imshow(in);
    subplot(1, 2, 2);
    imshow(foreground);
    pause(0.0001)
end

