function [ ] = task1_bg_experiment(SEQ, PATH, seq_name, samples, rho, adaptative, OPT, COLOR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    MODELING_RATIO = 0.5;

    n_samples = int32( (SEQ(2) - SEQ(1)) * MODELING_RATIO );
    
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_gaussian_modeling(PATH, SEQ, n_samples, COLOR);
    disp('MODELING DONE');
    
    % Perform Grid search for alpha and rho parameters (task2)
    switch OPT
        case 'GRID_SEARCH'
            disp('PARAMS GRID SEARCH -- BACKGROUND ESTIMATION');
            alpha = linspace(0, 1, samples);
            rho = linspace(0, 1, samples);
            for i = 1 : samples
                for j = 1 : samples
                    [TPaccum(i,j), FPaccum(i,j), FNaccum(i,j), TNaccum(i,j), prec(i,j), rec(i,j), f1score(i,j)] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i), rho(j), adaptative,COLOR);
                end
            end
            [valueR, idxR] = max(f1score);
            [valueC, idxC] = max(valueR);
            disp(sprintf('F1-score: %f -- Best Alpha: %f -- Best Rho: %f', valueC, alpha(idxR(idxC)), rho(idxR(idxC)) ));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR(idxC), idxC), rec(idxR(idxC), idxC)));
        case 'ALPHA_SEARCH'
            % Perform Search of the best Alpha with fixed rho (Task1)
            disp('BEST ALPHA SEARCH -- BACKGROUND ESTIMATION');
            alpha = linspace(0.1, 1, samples);
            for i = 1 : samples
                    [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i), prec(i), rec(i), f1score(i)] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i), rho, adaptative, COLOR);
            end
            [valueR, idxR] = max(f1score);
            disp(sprintf('F1-score: %f -- Alpha: %f', valueR, alpha(idxR)));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR), rec(idxR)));

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
            disp(sprintf('Area under the curve (auc): %f', auc));
        otherwise
            disp('Invalid option');
    end

  
end

