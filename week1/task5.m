function [ ] = task5()
   
    I45_1=im2double(imread('../training/image_0/000045_10.png'));
    train45 = imread('../training/flow_noc/000045_10.png');
    [t45u, t45v] = getFlowData(train45);

    x = 1:size(t45u, 2);
    y = 1:size(t45u, 1);
    
    downsample = 20;
    for i=1:size(t45u, 1)
       for j=1:size(t45u,2)
           if(mod(j,downsample) ~= 0 || mod(i,downsample)~=0)
               t45u(i,j) = 0;
               t45v(i,j) = 0;
           end
       end
    end
    
    
    imshow(I45_1);
    hold on
    quiver(x, y, t45u, t45v,100);
    set(gca,'Ydir','reverse')
    hold off
    
end


function [flow_u, flow_v] =getFlowData(flow_img)
    flow_u = (double(flow_img(:,:,1))-2^15)/64.0;
    flow_v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;
    
    flow_u = flow_u.*valid;
    flow_v = flow_v.*valid;
end
