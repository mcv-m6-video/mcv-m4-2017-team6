function [ ] = task3()
     close all;
     
     train45 = imread('../training/flow_noc/000045_10.png');
     res45 = imread('../results/LKflow_000045_10.png');
     [mse45, pepn45, error45] = getError(train45, res45);
     
     norm45 = error45 - min(error45(:));
     norm45 = norm45 ./ max(norm45(:));
     color45 = ind2rgb(floor(norm45*255), jet(256));
     
     

     
     train157 = imread('../training/flow_noc/000157_10.png');
     res157 = imread('../results/LKflow_000157_10.png');
     [mse157, pepn157, error157] = getError(train157, res157);
    
     norm157 = error157 - min(error157(:));
     norm157 = norm157 ./ max(norm157(:));
     color157 = ind2rgb(floor(norm157*255), jet(256));
   
     
     
     
     figure
     subplot(1, 2, 1);
     imshow(color45);
     subplot(1, 2, 2);
     imshow(color157);
     a=0;
     

end


function [mse, pepn, errorImg] = getError(train, result) 
    [ut, vt, valid] = getFlowData(train);
    [ur, vr] = getFlowData(result);
    
    error = sqrt((ut-ur).^2 + (vt-vr).^2);
    error(valid==0) = 0;
    n_valid = sum(valid(:)>0);

    mse = sum(error(:))/n_valid;
    pepn = sum(error(:)>3)/n_valid;
    errorImg = error;
end


function [flow_u, flow_v, valid] =getFlowData(flow_img)
    flow_u = (double(flow_img(:,:,1))-2^15)/64.0;
    flow_v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;

    flow_u = flow_u.*valid;
    flow_v = flow_v.*valid;
end
