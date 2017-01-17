function [ f1score ] = task4Prueba( dataset_path,ab,ba )

    INTERVALS=20;

   
    dataset_path = strcat(dataset_path, 'dataset/');
   
    SEQ(1,:) = [1050, 1350];
    PATH(1) = cellstr(strcat(dataset_path, 'baseline/highway/'));
    SEQ_NAME(1) = cellstr('HIGHWAY');
    backgroundPATH(1)=cellstr(strcat(dataset_path, 'baseline/highway/input/in000472.jpg'));
    RHO(1)=0.25;
    treshold(1) = 0;
    treshold2(1) = 0.2;
    
    SEQ(2,:) = [1460, 1560];
    PATH(2) = cellstr(strcat(dataset_path, 'dynamicBackground/fall/'));
    SEQ_NAME(2) = cellstr('FALL');
    backgroundPATH(2)=cellstr(strcat(dataset_path, 'dynamicBackground/fall/input/in001555.jpg'));
    RHO(2)=0.052632;
    treshold(2) = 0;
    treshold2(2) = 0.4;
        
    SEQ(3,:) = [950, 1050];
    PATH(3) = cellstr(strcat(dataset_path, 'cameraJitter/traffic/'));
    SEQ_NAME(3) = cellstr('TRAFFIC');
    backgroundPATH(3)=cellstr(strcat(dataset_path, 'cameraJitter/traffic/input/in000951.jpg'));
    RHO(3)= 0.157895;
    treshold(3) = ab;
    treshold2(3) = ba;
    
    
    for dataset=2:2
        TPaccum = 0; FPaccum = 0; FNaccum = 0; TNaccum = 0;
        backgroundImage = im2double(imread(cell2mat(backgroundPATH(dataset))));
        misc = (backgroundImage(:,:,1)+backgroundImage(:,:,2)+backgroundImage(:,:,3));
        misc(misc==0) = 0.0001;
        backgroundImage(:,:,1) = backgroundImage(:,:,1)./misc;
        backgroundImage(:,:,2) = backgroundImage(:,:,2)./misc;
        for nFrame=SEQ(dataset,1):SEQ(dataset,2)
            frame = im2double(( imread(strcat(cell2mat(PATH(dataset)), 'input/in00', sprintf('%04d',nFrame), '.jpg')) ));
            misc = (frame(:,:,1)+frame(:,:,2)+frame(:,:,3));
            misc(misc==0) = 0.0001;
            frame(:,:,1) = frame(:,:,1)./misc;
            frame(:,:,2) = frame(:,:,2)./misc;
            substraction = imabsdiff (backgroundImage, frame);
            substraction (substraction<treshold(dataset)) = 0;
            substraction (substraction>=treshold(dataset)) = 1;
%             substraction_aux=or(substraction(:,:,1),substraction(:,:,2));
%             substraction=or(substraction_aux,substraction(:,:,3));
%             imshow(substraction)
%             waitforbuttonpress;
            Res = imdilate (substraction,ones(9));
            
            BG=rgb2gray(imread(cell2mat(backgroundPATH(dataset))));
            frame2= rgb2gray(( imread(strcat(cell2mat(PATH(dataset)), 'input/in00', sprintf('%04d',nFrame), '.jpg')) ));
            FD = im2double(imabsdiff(BG,frame2));
            FD(FD<(treshold2(dataset))) = 0;
            FD(FD>=(treshold2(dataset))) = 1;
            
            DR = imdilate(FD,ones(3));
            re=  imfill(DR,'holes');
            
            finalRes(:,:,1) = Res(:,:,1).*re;
            finalRes(:,:,2) = Res(:,:,2).*re;
            finalRes(:,:,3) = Res(:,:,3).*re;
            
            mask_aux=or(finalRes(:,:,1),finalRes(:,:,2));
            mask=or(mask_aux,finalRes(:,:,3));
            GT_PATH = strcat(cell2mat(PATH(dataset)), 'groundtruth/');
            gt = imread(strcat(GT_PATH, 'gt00', sprintf('%04d',nFrame), '.png')) ;
            [TP, FP, FN, TN] = performance_pixel(mask, gt);
            TPaccum = TPaccum+TP;
            FPaccum = FPaccum + FP;
            FNaccum = FNaccum + FN;
            TNaccum = TNaccum + TN;
            
            
            
            imshow(mask)
            waitforbuttonpress;
        end
        [prec, rec, f1score] = performance_metrics(TPaccum, FPaccum, FNaccum); 
    end
end

