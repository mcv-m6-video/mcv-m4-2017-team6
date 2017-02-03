function [ segmentation, model ] = foreground_detection( frame, model )
%FOREGROUND_DETECTION Summary of this function goes here
%   Detailed explanation goes here
    
    color = model.color;
    
    in = frame;

    if ~color 
        if size(in,3)>1
            in = rgb2gray(in);
        end
    else
        in = changeColorSpace(in);
    end

    in = double(in);
    aux_foreground = abs(in - model.meanP) >= (model.alpha * (sqrt(model.varP) + 2.0));

    if model.opening > 0 % Perform opening to improve results
        for j=1:size(aux_foreground,3)
            aux_foreground(:,:,j) = bwareaopen(aux_foreground(:,:,j), model.opening);
        end
    end

    if model.morpho % Perform morphology to improve results
        for j=1:size(aux_foreground,3)
            aux_foreground(:,:,j) = imclose(aux_foreground(:,:,j), model.se);
        end
    end

    if model.filling == true % Perform hole filling to improve results
        for j=1:size(aux_foreground,3)
            aux_foreground(:,:,j) = imfill(aux_foreground(:,:,j), model.connectivity, 'holes');
        end
    end

    foreground = aux_foreground(:,:,1);
    if size(foreground, 3) > 1
        for j=2:size(foreground,3)
            foreground = foreground(:,:) .* aux_foreground(:,:,j);
        end
    end

    if model.adaptative
        % Update mean and variance (Adaptative model)
        model.meanP(~foreground) = model.rho*in(~foreground) + ...
                            (1 - model.rho)*model.meanP(~foreground);
        model.varP(~foreground) = model.rho*(in(~foreground) - model.meanP(~foreground)).^2 + ...
                            (1 - model.rho)*model.varP(~foreground);
    end

    if model.shadow %task4
        foreground = hsv_shadow_removal(in, meanP, foreground);
    end
    
    segmentation = foreground;
       
end

