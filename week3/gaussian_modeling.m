function [ p_mean, p_var ] = gaussian_modeling(IN_PATH, sequence, n_samples, color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    IN_PATH = strcat(IN_PATH, 'input/');
    first = sequence(1);
    last = first + n_samples;
    
    in = rgb2gray( imread(strcat(IN_PATH, 'in000001.jpg')) );
    
    if color
        seq = zeros(size(in, 1), size(in, 2), 3, n_samples);
        count = 1;
        for i = first : last
            in = imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg'));
            in = changeColorSpace(in);
            %in = cat(3, in(:,:,1), in(:,:,2));
            seq(:,:,:,count) = in(:,:,:);
            count = count + 1;
        end

        p_mean = mean(seq, 4);
        p_var = var(seq, 0, 4);
    else
        seq = zeros(size(in, 1), size(in, 2), n_samples);
        count = 1;
        for i = first : last
            in = rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
            seq(:,:,count) = in(:,:);
            count = count + 1;
        end

        p_mean = mean(seq, 3);
        p_var = var(seq, 0, 3);
    end
    
    % (DEBUG) View mean and variance to assess that they have been computed right
    if false
        imshow(mat2gray(p_mean));
        waitforbuttonpress;
        imshow(mat2gray(p_var));
        waitforbuttonpress;
    end

end

