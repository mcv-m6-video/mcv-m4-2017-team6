function [ ] = task1_bg_experiment(SEQ, PATH, seq_name, samples, rho, adaptative, OPT, COLOR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    MODELING_RATIO = 0.5;

    n_samples = int32( (SEQ(2) - SEQ(1)) * MODELING_RATIO );
    
    disp('MODELING THE BACKGROUND');
    [meanP, varP] = task1_gaussian_modeling(PATH, SEQ, n_samples, COLOR);
    disp('MODELING DONE');
%     imshow(mat2gray(meanP));
%     figure
%     imshow(mat2gray(varP));
%     waitforbuttonpress;
    
    % Perform Grid search for alpha and rho parameters (task2)
    switch OPT
        case 'GRID_SEARCH'
            disp('PARAMS GRID SEARCH -- BACKGROUND ESTIMATION');
            alpha = linspace(0, 5, samples);
            rho = linspace(0, 1, samples);
            
            for i = 1 : samples
                for j = 1 : samples
                    [TPaccum(i,j), FPaccum(i,j), FNaccum(i,j), TNaccum(i,j), prec(i,j), rec(i,j), f1score(i,j)] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i), rho(j), adaptative,COLOR);
                end
            end
            [valueR, idxR] = max(f1score);
            [valueC, idxC] = max(valueR);
            [m n] = max(f1score(:));
            [x y] = ind2sub(size(f1score),n);
            disp(sprintf('F1-score: %f -- Best Alpha: %f -- Best Rho: %f', valueC, alpha(x), rho(y) ));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR(idxC), idxC), rec(idxR(idxC), idxC)));
            surf(alpha, rho, f1score);
            title(strcat(seq_name, '- F1 Score'));
            xlabel('Alpha');
            ylabel('Rho');
            zlabel('F1-Score');
        case 'RHO_SEARCH'
            % Fix alpha and search for a good rho (task 2)
            disp('BEST RHO SEARCH -- BACKGROUND ESTIMATION');
            % alpha = 1.832323; % hardcoded for highway
            % alpha = 4.5; % FALL
            alpha = 1.8; % TRAFFIC
            rho = linspace(0.0, 1, samples);
            for i = 1 : samples
                    [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i), prec(i), rec(i), f1score(i)] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha, rho(i), adaptative, COLOR);
            end
            [valueR, idxR] = max(f1score);
            disp(sprintf('F1-score: %f -- Rho: %f', valueR, rho(idxR)));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR), rec(idxR)));
            
             % TP, TN, FP, FN vs Rho
            figure
            plot(rho, TPaccum, rho, FPaccum, rho, FNaccum, rho, TNaccum);
            title(strcat(seq_name, '- Pixel evaluation'));
            xlabel('Rho (adaptative)');
            ylabel('Num. pixels');
            legend('TP', 'FP', 'FN', 'TN');

            % F1-score vs Alpha
            figure
            plot(rho, f1score);
            title(strcat(seq_name, '- F1 vs Rho'));
            xlabel('Rho (rho)');
            ylabel('F1 Score');
            %legend('TP', 'FP', 'FN', 'TN');

            figure
            plot(rec, prec);
            title(strcat(seq_name, ' - Precision Recall'));
            xlabel('Recall');
            ylabel('Precision');
            auc = samples * trapz(prec);
            %legend(strcat('AUC - ', num2str(auc)));
            disp(sprintf('Area under the curve (auc): %f', auc));
            
        case 'ALPHA_SEARCH'
            % Perform Search of the best Alpha with fixed rho (Task1)
            disp('BEST ALPHA SEARCH -- BACKGROUND ESTIMATION');
            alpha = linspace(0.1, 5, samples);
            for i = 1 : samples
                    [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i), prec(i), rec(i), f1score(i)] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i), rho, adaptative, COLOR);
            end
            [valueR, idxR] = max(f1score);
            disp(sprintf('F1-score: %f -- Alpha: %f', valueR, alpha(idxR)));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR), rec(idxR)));

            % TP, TN, FP, FN vs Alpha
            figure
            plot(alpha, TPaccum, alpha, FPaccum, alpha, FNaccum, alpha, TNaccum);
            title(strcat(seq_name, '- Pixel evaluation'));
            xlabel('Alpha (threshold)');
            ylabel('Num. pixels');
            legend('TP', 'FP', 'FN', 'TN');

            % F1-score vs Alpha
            figure
            plot(alpha, f1score);
            title(strcat(seq_name, '- F1 vs Alpha'));
            xlabel('Alpha (threshold)');
            ylabel('F1 Score');
            %legend('TP', 'FP', 'FN', 'TN');

            figure
            plot(rec, prec);
            title(strcat(seq_name, ' - Precision Recall'));
            xlabel('Recall');
            ylabel('Precision');
            auc = samples * trapz(prec);
            legend(sprintf('AUC: %f', auc));
            disp(sprintf('Area under the curve (auc): %f', auc));
        case 'fixed'
            disp('FIXED PARAMETERS EVALUATION -- BACKGROUND ESTIMATION');
            alpha = 3.75;
            rho = 0.25;
            [TPaccum, FPaccum, FNaccum, TNaccum, prec, rec, f1score] = ...
                        task1_bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha, rho, adaptative, COLOR);
                              
            disp(sprintf('F1-score: %f -- Alpha: %f', f1score, alpha));
            disp(sprintf('Precision: %f -- Recall: %f', prec, rec));
                    
        otherwise
            disp('Invalid option');
    end

  
end

