function [mse, pepn, errorImg] = getError(train, result) 
    [ut, vt, valid] = getFlowData(train);
    
    ur = result(:,:,1);
    vr = result(:,:,2);
    
    %[ur, vr] = [result(:,:,1), result(:,:,2)];
    
    error = sqrt((ut-ur).^2 + (vt-vr).^2);
    error(valid==0) = 0;
    n_valid = sum(valid(:)>0);

    mse = sum(error(:))/n_valid;
    pepn = sum(error(:)>3)/n_valid;
    errorImg = error;
end