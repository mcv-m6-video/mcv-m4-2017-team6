function [ foreground ] = hsv_shadow_removal( expected, observed, foreground )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    alpha = 0.25;
    beta = 0.75;
    ts = 0.5;
    th = 0.25;
    
    expected = rgb2hsv(expected);
    observed = rgb2hsv(observed);
        
    sp = (observed(:,:,3)./expected(:,:,3) >= alpha) & (observed(:,:,3)./expected(:,:,3) <= beta) & ((observed(:,:,2)-expected(:,:,2)) <= ts) & (abs(observed(:,:,1)-expected(:,:,1)) <= th);
    
    foreground = foreground .* ~sp;
 end

