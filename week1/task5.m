function [ ] = task5()
   
    I45_1=im2double(imread('../training/imag_0/000045_10.png'));
    train45 = imread('../training/flow_noc/000045_10.png');
    [t45u, t45v] = getFlowData(train45);

    [x, y] = meshgrid(1:size(t45u, 2), 1:size(t45u, 1));
    quiver(x, y, t45u, t45v, 1.5, 'r', 'LineWidth', 1.2);
    set(gca,'Ydir','reverse')
    
end


function [u, v] =getFlowData(flow_img)
    u = (double(flow_img(:,:,1))-2^15)/64.0;
    v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;
    
    u = u.*valid;
    v = v.*valid;
end
