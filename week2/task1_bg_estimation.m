function [TPaccum, FPaccum, FNaccum, TNaccum, prec, rec, f1score] = ...
    task1_bg_estimation(PATH, sequence, meanP, varP, n_samples, alpha, rho, adaptative, color)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    IN_PATH = strcat(PATH, 'input/');
    GT_PATH = strcat(PATH, 'groundtruth/');
        
    first = sequence(1) + n_samples + 1;
    last = sequence(2);
    
    TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
    for i = first : last
        in = imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg') );
        if ~color
            in = rgb2gray(in);
        end
        gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png'));
        in = im2double(in);
        
        foreground = abs(in - meanP) <= (alpha * (varP + 2.0));
        
        if adaptative
            % Update mean and variance (Adaptative model)
            meanP(~foreground) = rho*in(~foreground) + ...
                                (1 - rho)*meanP(~foreground);
            varP(~foreground) = rho*(in(~foreground) - meanP(~foreground)).^2 + ...
                                (1 - rho)*varP(~foreground);
        end
        
        [TP, FP, FN, TN] = performance_pixel(foreground, gt);
        
        TPaccum = TPaccum + TP;
        FPaccum = FPaccum + FP;
        FNaccum = FNaccum + FN;
        TNaccum = TNaccum + TN;
        
        %plot_estimation(foreground, in, gt);
    end
    [prec, rec, f1score] = performance_metrics(TPaccum, FPaccum, FNaccum);
end

function [] = plot_estimation(foreground, in, gt)
    subplot(2, 2, 1);
    imshow(in);
    subplot(2, 2, 2);
    imshow(foreground);
    subplot(2, 2, 3)
    imshow(gt==255);
    pause(0.0001)
end

