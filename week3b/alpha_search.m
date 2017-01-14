function [ prec,rec,auc] = alpha_search( samples,SEQ, PATH, rho,seq_name,connectivity,  filling, opening, morpho)
            MODELING_RATIO = 0.5;
            n_samples = int32( (SEQ(2) - SEQ(1)) * MODELING_RATIO );
            [meanP, varP] = gaussian_modeling(PATH, SEQ, n_samples, false);
            % Perform Search of the best Alpha with fixed rho (Task1)
            disp(strcat(seq_name,' - BEST ALPHA SEARCH -- BACKGROUND ESTIMATION'));
            alpha = linspace(0.1, 5, samples);
            for i = 1 : samples
                    [TPaccum(i), FPaccum(i), FNaccum(i), TNaccum(i), prec(i), rec(i), f1score(i)] = ...
                        bg_estimation(PATH, SEQ, meanP, varP, n_samples, alpha(i), rho, true, false,connectivity,  filling, opening, morpho);
            end
            [valueR, idxR] = max(f1score);
            disp(sprintf('F1-score: %f -- Alpha: %f', valueR, alpha(idxR)));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR), rec(idxR)));

%             % TP, TN, FP, FN vs Alpha
%             figure
%             plot(alpha, TPaccum, alpha, FPaccum, alpha, FNaccum, alpha, TNaccum);
%             title(strcat(seq_name, '- Pixel evaluation'));
%             xlabel('Alpha (threshold)');
%             ylabel('Num. pixels');
%             legend('TP', 'FP', 'FN', 'TN');

%             % F1-score vs Alpha
%             figure
%             plot(alpha, f1score);
%             title(strcat(seq_name, '- F1 vs Alpha'));
%             xlabel('Alpha (threshold)');
%             ylabel('F1 Score');
%             %legend('TP', 'FP', 'FN', 'TN');
% 
%             figure
%             plot(rec, prec);
%             title(strcat(seq_name, ' - Precision Recall'));
%             xlabel('Recall');
%             ylabel('Precision');
            prec(isnan(prec)) = 0 ;
            rec(isnan(rec)) = 0 ;
            auc = trapz(prec,rec);
%             legend(sprintf('AUC: %f', auc));
            disp(sprintf('Area under the curve (auc): %f', auc));
end

