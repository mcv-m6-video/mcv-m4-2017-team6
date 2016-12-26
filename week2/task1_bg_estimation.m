function [  ] = task1_bg_estimation(IN_PATH, sequence, meanP, varP)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    IN_PATH = strcat(IN_PATH, 'input/');
        
    first = sequence(1);
    last = sequence(2);
    
    alpha = 0.5;
    for i = first : last
        i
        in = rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
        in = im2double(in);
%         foreground = zeros(size(in, 1), size(in, 2));
%         for j = 1 : size(in, 2)
%             for k = 1 : size(in, 1)
%                 if abs(in(k,j) - meanP(k,j)) >= alpha * (varP(k,j) + 2.0)
%                     foreground(k,j) = 1;
%                 end
%             end
%         end
        
        foreground = zeros(size(in, 1), size(in, 2));
        foreground = abs(in - meanP) >= (alpha * (varP + 2.0));
        
        subplot(1, 2, 1);
        imshow(in);
        subplot(1, 2, 2);
        imshow(foreground);
        pause(0.01)
    end
end

