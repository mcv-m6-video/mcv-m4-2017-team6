function [ ] = task3()
     close all;
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
     
     error45 = sqrt((t45u-r45u + t45v-r45v).^2);
     norm45 = error45 - min(error45(:));
     norm45 = norm45 ./ max(norm45(:));
     color45 = ind2rgb(floor(norm45*255), jet(256));
     
     
     error157 = sqrt((t157u-r157u + t157v-r157v).^2);
     norm157 = error157 - min(error157(:));
     norm157 = norm157 ./ max(norm157(:));
     color157 = ind2rgb(floor(norm157*255), jet(256));
     
     figure
     subplot(1, 2, 1);
     imshow(color45);
     subplot(1, 2, 2);
     imshow(color157);
     

end

function [flow_u, flow_v] =getFlowData(flow_img)
    flow_u = (double(flow_img(:,:,1))-2^15)/64.0;
    flow_v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;
    
    flow_u = flow_u.*valid;
    flow_v = flow_v.*valid;
end
