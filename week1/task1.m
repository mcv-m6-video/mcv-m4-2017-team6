function [ ] = task1()
%TASK1 Segmentation metrics. Understand precision & recall.
%   Implement and compute the specified measures for sequences A and B

    %1201-1400 HIGHWAY (200 frames)
    GT_PATH = '../highway/groundtruth/';
    TEST_PATH = '../results/highway/';
    total_tp_a = 0; total_fp_a = 0; total_tn_a = 0; total_fn_a = 0;
    total_tp_b = 0; total_fp_b = 0; total_tn_b = 0; total_fn_b = 0;
    for i=1201:1400
        gt = imread(strcat(GT_PATH, 'gt00', int2str(i), '.png'));
        test_a = imread(strcat(TEST_PATH, 'test_A_00', int2str(i), '.png')) > 0;
        test_b = imread(strcat(TEST_PATH, 'test_B_00', int2str(i), '.png')) > 0;

        % The groundtruth images contain 5 labels namely:
        % 0 : Static
        % 50 : Hard shadow
        % 85 : Outside region of interest
        % 170 : Unknown motion (usually around moving objects, due to semi-transparency and motion blur)
        % 255 : Motion

        % choose which values of gt labels are considered as motion
        % above this value (included) will be considered as motion
        motion = 170;
        
        gt_mask = gt >= motion;
        
        % results for test_A
        tp_a = sum(test_a(gt_mask)); % True Positive
        fp_a = sum(test_a(~gt_mask)); % False Positive
        tn_a = sum(~test_a(~gt_mask)); % True Negative
        fn_a = sum(~test_a(gt_mask)); % False Negative
        
        % results for test_B
        tp_b = sum(test_b(gt_mask)); % True Positive
        fp_b = sum(test_b(~gt_mask)); % False Positive
        tn_b = sum(~test_b(~gt_mask)); % True Negative
        fn_b = sum(~test_b(gt_mask)); % False Negative
        
        % Accumulate results
        total_tp_a = total_tp_a+tp_a; total_fp_a = total_fp_a+fp_a; total_tn_a = total_tn_a+tn_a; total_fn_a = total_fn_a+fn_a;
        total_tp_b = total_tp_b+tp_b; total_fp_b = total_fp_b+fp_b; total_tn_b = total_tn_b+tn_b; total_fn_b = total_fn_b+fn_b;
    end
    disp('Test A');
    disp(['True Positive: ', num2str(total_tp_a)]);
    disp(['True Negative: ', num2str(total_tn_a)]);
    disp(['False Positive: ', num2str(total_fp_a)]);
    disp(['False Negative: ', num2str(total_fn_a)]);
    prec = total_tp_a/(total_tp_a+total_fp_a);
    rec = total_tp_a/(total_tp_a+total_fn_a);
    disp(['Precision: ', num2str(prec)]);
    disp(['Recall: ', num2str(rec)]);
    disp(['F1 Score: ', num2str((2*prec*rec)/(prec+rec))]);
    disp(sprintf(' '));
    
    disp('Test B');
    disp(['True Positive: ', num2str(total_tp_b)]);
    disp(['True Negative: ', num2str(total_tn_b)]);
    disp(['False Positive: ', num2str(total_fp_b)]);
    disp(['False Negative: ', num2str(total_fn_b)]);
    prec = total_tp_b/(total_tp_b+total_fp_b);
    rec = total_tp_b/(total_tp_b+total_fn_b);
    disp(['Precision: ', num2str(prec)]);
    disp(['Recall: ', num2str(rec)]);
    disp(['F1 Score: ', num2str((2*prec*rec)/(prec+rec))]);
end

