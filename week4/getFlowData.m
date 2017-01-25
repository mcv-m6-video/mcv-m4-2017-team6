function [flow_u, flow_v, valid] =getFlowData(flow_img)
    flow_u = (double(flow_img(:,:,1))-2^15)/64.0;
    flow_v = (double(flow_img(:,:,2))-2^15)/64.0;
    valid = flow_img(:,:,3)>0;

    flow_u = flow_u.*valid;
    flow_v = flow_v.*valid;
end