function [mse, pepn, errorImg] = getError(train, ur, vr) 
    [ut, vt, valid] = getFlowData(train);
        
    error = sqrt((ut-ur).^2 + (vt-vr).^2);
    error(valid==0) = 0;
    n_valid = sum(valid(:)>0);

    mse = sum(error(:))/n_valid;
    pepn = sum(error(:)>3)/n_valid;
    errorImg = error;
end