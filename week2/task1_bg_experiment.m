function [ ] = task1_bg_experiment(SEQ, PATH, seq_name, intervals)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    MODELING_RATIO = 0.5;

    n_samples = int32( (SEQ(2) - SEQ(1)) * MODELING_RATIO );
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_gaussian_modeling(PATH, SEQ, n_samples);
    disp('MODELING DONE');
    
    samples = intervals;
    alpha = linspace(0.1, 1, samples);
    TPaccum = zeros(1, samples);
    FPaccum = zeros(1, samples);
    FNaccum = zeros(1, samples);
    TNaccum = zeros(1, samples);
    prec = zeros(1, samples);
    rec = zeros(1, samples);
    
    disp('BACKGROUND ESTIMATION');
    for i = 1 : samples
        [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i), prec(i), rec(i)] = ...
            task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i));
    end
    
    figure
    plot(alpha, TPaccum, alpha, FPaccum, alpha, FNaccum, alpha, TNaccum);
    title(strcat(seq_name, '- Pixel evaluation'));
    xlabel('Alpha (threshold)');
    ylabel('Num. pixels');
    legend('TP', 'FP', 'FN', 'TN');

    figure
    plot(rec, prec);
    title(strcat(seq_name, ' - Precision Recall'));
    xlabel('Recall');
    ylabel('Precision');
    auc = samples * trapz(prec);
    %legend(strcat('AUC - ', num2str(auc)));
end

