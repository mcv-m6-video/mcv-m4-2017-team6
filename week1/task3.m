function [ ] = task3()
    close all;

    
%     GT_PATH = '../training/image_0/';
%     TEST_PATH = '../testing/image_0/';
% 
%     I45_1=im2double(imread(strcat(GT_PATH,'000045_10.png')));
%     I45_2=im2double(imread(strcat(GT_PATH,'000045_11.png')));
%     opticalFlow45 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameSource', 'Input port')                                                          
%     movement45=step(opticalFlow45, I45_1, I45_2);
%     
%    
%     I157_1=im2double(imread(strcat(GT_PATH,'000157_10.png')));
%     I157_2=im2double(imread(strcat(GT_PATH,'000157_11.png')));
%     opticalFlow157 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameSource', 'Input port')                                                          
%     movement157= step(opticalFlow157, I157_1, I157_2);
%
%     imshow(movement157)
%     hold on;
%     [gx,gy] = gradient(movement157);
%     [Nx, Ny] = size(movement157);
%     xidx = 1:10:Nx;
%     yidx = 1:10:Ny;
%     [X,Y] = meshgrid(xidx,yidx);
%     quiver(Y',X',abs(gx(xidx,yidx)),abs(gy(xidx,yidx)));



     train45 = imread('../training/flow_noc/000045_10.png');
     [t45u, t45v] = getFlowData(train45);
     res45 = imread('../results/LKflow_000045_10.png');
     [r45u, r45v] = getFlowData(res45);
     mse45 = mean(mean((t45u-r45u + t45v-r45v).^2));
     pepn45 = mean(mean(sqrt((t45u-r45u + t45v-r45v).^2)>3))*100;
     
     subplot(2,2,1);
     imshow((t45u-r45u + t45v-r45v).^2, [0, max(max(t45v-r45v))]);
     
     subplot(2,2,2);
     imshow(sqrt((t45u-r45u + t45v-r45v).^2)>3, [0, 1]);
     
     [train157, map] = imread('../training/flow_noc/000157_10.png');
     [t157u, t157v] = getFlowData(train157);
     res157 = imread('../results/LKflow_000157_10.png');
     [r157u, r157v] = getFlowData(res157);
     mse157 = mean(mean((t157u-r157u + t157v-r157v).^2));
     pepn157 = mean(mean(sqrt((t157u-r157u + t157v-r157v).^2)>3))*100;
          
     subplot(2,2,3);
     imshow((t157u-r157u + t157v-r157v).^2, [0, max(max(t157v-r157v))]);
     
     subplot(2,2,4);
     imshow(sqrt((t157u-r157u + t157v-r157v).^2)>3, [0, 1]);
     
     cerr45 = (t45u-r45u + t45v-r45v).^2;
     cerr157 = (t157u-r157u + t157v-r157v).^2;
     figure
     subplot(1, 2, 1);
     imshow(cerr45);
     colormap jet;
     subplot (1, 2, 2);
     imshow(cerr157);
     colormap jet;

end

function [u, v] =getFlowData(flow_img)
    u = (double(flow_img(:,:,1))-2^15)/64.0;
    v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;
    
    u = u.*valid;
    v = v.*valid;
end