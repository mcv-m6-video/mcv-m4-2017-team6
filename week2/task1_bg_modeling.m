function [ p_mean, p_var ] = task1_bg_modeling(IN_PATH, sequence, n_samples)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    IN_PATH = strcat(IN_PATH, 'input/');
    first = sequence(1);
    %last = first + n_samples;
    last = sequence(2);
    
    in = rgb2gray( imread(strcat(IN_PATH, 'in000001.jpg')) );
    seq = zeros(size(in, 1), size(in, 2), n_samples);
    
    for i = first : last
        in = rgb2gray( imread(strcat(IN_PATH, 'in00', sprintf('%04d',i), '.jpg')) );
        seq(:,:,i) = in(:,:);
 %       imshow(in);
  %      pause(0.01)
    end
    
    p_mean = mean(seq, 3);
    p_var = var(seq, 0, 3);
    

end

