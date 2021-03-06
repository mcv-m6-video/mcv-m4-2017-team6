function [TPaccum, FPaccum, FNaccum, TNaccum, prec, rec, f1score] = ...
    bg_estimation(PATH, sequence, init_meanP, init_varP, n_samples, alpha, rho, adaptative, color, connectivity,  filling, opening, morpho, se, shadow)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    IN_PATH = strcat(PATH, 'input/');
    GT_PATH = strcat(PATH, 'groundtruth/');
    
    meanP = init_meanP;
    varP = init_varP;
        
    first = sequence(1) + n_samples + 1;
    last = sequence(2);
    
    
     
    TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
    for i = first : last
        in = imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg') );

        if ~color 
            if size(in,3)>1
                in = rgb2gray(in);
            end
        else
            in = changeColorSpace(in);
            %in = cat(3, in(:,:,1), in(:, :,2));
        end
        gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',i), '.png'));
        in = double(in);
              
        
        aux_foreground = abs(in - meanP) >= (alpha * (sqrt(varP) + 2.0));
        
        
        
        if opening > 0
            for j=1:size(aux_foreground,3)
                aux_foreground(:,:,j) = bwareaopen(aux_foreground(:,:,j), opening);
            end
        end
        
        if morpho %task3
            for j=1:size(aux_foreground,3)
               % aux_foreground(:,:,j) = imopen(aux_foreground(:,:,j), se);
                aux_foreground(:,:,j) = imclose(aux_foreground(:,:,j), se);
            end
        end
        
        if filling == true
            for j=1:size(aux_foreground,3)
                aux_foreground(:,:,j) = imfill(aux_foreground(:,:,j), connectivity, 'holes');
            end
        end
        
        
        
        foreground = aux_foreground(:,:,1);
        if size(foreground, 3) > 1
            for j=2:size(foreground,3)
                foreground = foreground(:,:) .* aux_foreground(:,:,j);
            end
        end
        
        %imshow(in);
        %waitforbuttonpress;
%         imshow(mat2gray(foreground));
%         waitforbuttonpress;
        
        if adaptative
            % Update mean and variance (Adaptative model)
            meanP(~foreground) = rho*in(~foreground) + ...
                                (1 - rho)*meanP(~foreground);
            varP(~foreground) = rho*(in(~foreground) - meanP(~foreground)).^2 + ...
                                (1 - rho)*varP(~foreground);
        end
        
        
        if shadow %task4
            foreground = hsv_shadow_removal(in, meanP, foreground);
        end
        
        %imwrite(foreground, strcat('foreground_results/compensated/', 'in00', sprintf('%04d',i), '.png') )
        
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

