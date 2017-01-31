function [udir_accum, vdir_accum] = motion_compensation(u, v, udir_accum, vdir_accum)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    u_flat = u(:);
    v_flat = v(:);

    nbins_x = abs(min(u_flat) - max(u_flat));
    nbins_y = abs(min(v_flat) - max(u_flat));
    data = [u_flat, v_flat];
    hist_mat = hist3(data, [nbins_x nbins_y]);

    u_mode = mode(u_flat);
    v_mode = mode(v_flat);
    [m n] = max(hist_mat(:));
    [x y] = ind2sub(size(hist_mat),n);
    
    udir_accum = udir_accum + u_mode;
    vdir_accum = vdir_accum + v_mode;

end

