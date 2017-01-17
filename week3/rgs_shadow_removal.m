function [ foreground ] = rgs_shadow_removal( observed, expected, foreground )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    alpha =  -50.0;
    beta = 150.0;
    s = observed(:,:,1)+observed(:,:,2)+observed(:,:,3);
    st = expected(:,:,1)+expected(:,:,2)+expected(:,:,3);


    foreground = foreground .* ~(st./s > beta | st./s < alpha);
end

