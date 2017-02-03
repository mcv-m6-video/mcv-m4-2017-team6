function [ output_args ] = find_best_alpha_rho( input_args )
%TASK1_1 Summary of this function goes here
%   Detailed explanation goes here
    seq_path = '../dataset2014/dataset/baseline/highway/input/';
    GT_PATH = strcat('../dataset2014/dataset/baseline/highway/', 'groundtruth/');
    SEQ = [1050, 1350];
    
    % We start by modeling the background
    model = {};
    model.modeling_ratio = 0.5;
    model.color = false;
    
    n_samples = int32( (SEQ(2) - SEQ(1)) * model.modeling_ratio );
    [meanP, varP] = background_modeling(seq_path, SEQ, n_samples, model.color);
    model.n_samples = n_samples;
    model.meanP = meanP;
    model.varP = varP;
    
    % parameters for foreground detection
    model.opening = 0; % 1000
    model.morpho = false;
    model.se = strel('octagon',18);
    model.adaptative = true;
    model.shadow = false;
    model.filling = false;
    model.connectivity = 4;
    
    %SEARCH = 'ALPHA_SEARCH';
    SEARCH = 'GRID_SEARCH';
    switch SEARCH
        case 'GRID_SEARCH'
            samples = 5;
            disp('PARAMS GRID SEARCH -- BACKGROUND ESTIMATION');
            alpha = linspace(0, 5, samples);
            rho = linspace(0, 1, samples);
            
            for i = 1 : samples
                for j = 1 : samples
                    disp(sprintf('%d, %d', i, j));
                    
                    model.alpha = alpha(i);
                    model.rho = rho(j);
                    
                    % Recompute params
                    [meanP, varP] = background_modeling(seq_path, SEQ, n_samples, model.color);
                    model.n_samples = n_samples;
                    model.meanP = meanP;
                    model.varP = varP;
    
%                     imshow(mat2gray(model.meanP))
%                     waitforbuttonpress;
                    [prec(i,j), rec(i,j), f1score(i,j), model] = get_scores(seq_path, GT_PATH, model, SEQ);
                    
                    disp(sprintf('alpha: %f, rho: %f, f1: %f', model.alpha, model.rho, f1score(i,j)));
%                     imshow(mat2gray(model.meanP))
%                     waitforbuttonpress;
                end
            end
            [valueR, idxR] = max(f1score);
            [valueC, idxC] = max(valueR);
            [m n] = max(f1score(:));
            [x y] = ind2sub(size(f1score),n);
            disp(sprintf('F1-score: %f -- Best Alpha: %f -- Best Rho: %f', valueC, alpha(x), rho(y) ));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR(idxC), idxC), rec(idxR(idxC), idxC)));
            surf(rho, alpha, f1score);
            title(strcat('- F1 Score'));
            xlabel('Rho');
            ylabel('Alpha');
            zlabel('F1-Score');
            
        case 'ALPHA_SEARCH'
            samples = 20;
            alpha = linspace(0, 5, samples);
            
            for i = 1 : samples
                i
                model.alpha = alpha(i);
                model.rho = 0.157895;

                % Recompute params
                [meanP, varP] = background_modeling(seq_path, SEQ, n_samples, model.color);
                model.n_samples = n_samples;
                model.meanP = meanP;
                model.varP = varP;

                [prec(i), rec(i), f1score(i), model] = get_scores(seq_path, GT_PATH, model, SEQ);
            end            
            
            [valueR, idxR] = max(f1score);
            disp(sprintf('F1-score: %f -- Alpha: %f', valueR, alpha(idxR)));
            disp(sprintf('Precision: %f -- Recall: %f', prec(idxR), rec(idxR)));
            auc = trapz(prec,rec);
%             legend(sprintf('AUC: %f', auc));
            disp(sprintf('Area under the curve (auc): %f', auc));
    end

end

function [prec, rec, f1score, model] = get_scores(seq_path, GT_PATH, model, SEQ)
    TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
    for i = SEQ(1)+model.n_samples : SEQ(2) % Only frames to evaluate
        frame = rgb2gray( imread(strcat(seq_path, 'in00', sprintf('%04d',i), '.jpg')) );
        gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png'));

        [segmentation, model] = foreground_detection(frame, model);

        to_show = [frame, uint8(segmentation)*255];
        imshow(to_show);
        pause(0.000001);

        [TP, FP, FN, TN] = performance_pixel(segmentation, gt);

        TPaccum = TPaccum + TP;
        FPaccum = FPaccum + FP;
        FNaccum = FNaccum + FN;
        TNaccum = TNaccum + TN;
    end
    
    [prec, rec, f1score] = performance_metrics(TPaccum, FPaccum, FNaccum);
end

function [TP, FP, FN, TN] = performance_pixel(pixelCandidates, gt)
    
    pixelGt = gt==255;
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

function [prec, rec, f1score] = performance_metrics(TP, FP, FN)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    prec = TP / (TP + FP);
    rec = TP / (TP + FN); 
    f1score = (2  * prec * rec) / (prec + rec);
end

