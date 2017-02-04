function [ tform ] = homo(orig, dest)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here    
    tform = fitgeotrans(orig, dest, 'projective');
end

