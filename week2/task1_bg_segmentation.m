function [ ] = task1_bg_segmentation(SEQ, PATH, seq_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    MODELING_RATIO = 0.5;

    n_samples = int32( (SEQ(2) - SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_bg_modeling(PATH, SEQ, n_samples);
    disp('MODELING DONE');
    
    samples = 10;
    alpha = linspace(0.1, 1, samples);
    TPaccum = zeros(samples);
    FPaccum = zeros(samples);
    FNaccum = zeros(samples);
    TNaccum = zeros(samples);
    
    disp('BACKGROUND ESTIMATION');
    for i = 1 : samples
        [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i)] = ...
            task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i));
    end
    
    figure
    plot(alpha, TPaccum, alpha, FPaccum, alpha, FNaccum, alpha, TNaccum);
    title(seq_name);
    xlabel('Alpha (threshold)');
    ylabel('Num. pixels');
    legend('TP', 'FP', 'FN', 'TN');

end

