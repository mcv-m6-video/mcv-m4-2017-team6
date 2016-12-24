function [  ] = task1_bg_estimation(IN_PATH, HIGHWAY_SEQ, meanP, varP, n_samples)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    first = HIGHWAY_SEQ(1) + n_samples + 1;
    last = HIGHWAY_SEQ(2);
    
    alpha = 1.0;
    for i = first : last
        i
        in = rgb2gray( imread(strcat(IN_PATH, 'in00', int2str(i), '.jpg')) );
        in = im2double(in);
        foreground = zeros(size(in, 1), size(in, 2));
        for j = 1 : size(in, 2)
            for k = 1 : size(in, 1)
                if abs(in(k,j) - meanP(k,j)) >= alpha * (varP(k,j) + 2.0)
                    foreground(k,j) = 1;
                end
            end
        end
        
        %foreground = zeros(size(in, 1), size(in, 2));
        %foreground = abs(in - meanP) >= (alpha * (varP + 2.0));
        if any(foreground(:))
            disp('juan')
        end
        imshow(foreground, [0 255]);
    end
end

