function [ ] = task3()
    GT_PATH = '../training/image_0/';
    TEST_PATH = '../testing/image_0/';

    I45_1=im2double(imread(strcat(GT_PATH,'000045_10.png')));
    I45_2=im2double(imread(strcat(GT_PATH,'000045_11.png')));
    opticalFlow45 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameSource', 'Input port')                                                          
    movement45=step(opticalFlow45, I45_1, I45_2);
   
    I157_1=im2double(imread(strcat(GT_PATH,'000157_10.png')));
    I157_2=im2double(imread(strcat(GT_PATH,'000157_11.png')));
    opticalFlow157 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameSource', 'Input port')                                                          
    movement157= step(opticalFlow157, I157_1, I157_2);
%     imshow(movement157)
%     hold on;
%     [gx,gy] = gradient(movement157);
%     [Nx, Ny] = size(movement157);
%     xidx = 1:10:Nx;
%     yidx = 1:10:Ny;
%     [X,Y] = meshgrid(xidx,yidx);
%     quiver(Y',X',abs(gx(xidx,yidx)),abs(gy(xidx,yidx)));
    
end