function [prec, rec, f1score] = performance_metrics(TP, FP, FN)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    prec = TP / (TP + FP);
    rec = TP / (TP + FN); 
    f1score = (2  * prec * rec) / (prec + rec);
end

