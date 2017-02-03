function [ p_mean, p_var ] = background_modeling(IN_PATH, sequence, n_samples, color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    first = sequence(1);
    last = first + n_samples; 
    in = ( imread(strcat(IN_PATH, 'in00', sprintf('%04d',first), '.jpg')) );
    if size(in,3)>1
          in = rgb2gray(in);
    end
   
    if color
        seq = zeros(size(in, 1), size(in, 2), 3, n_samples);
        count = 1;
        for i = first : last
            in = imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg'));
            in = changeColorSpace(in);
            seq(:,:,:,count) = in(:,:,:);
            count = count + 1;
        end

        p_mean = mean(seq, 4);
        p_var = var(seq, 0, 4);
    else
        seq = zeros(size(in, 1), size(in, 2), n_samples);
        count = 1;
        for i = first : last
            in = ( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
            if size(in,3)>1
                in = rgb2gray(in);
            end
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