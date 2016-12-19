function [ ] = task4()
%TASK1 De-synchornized results.
%   Forward de-synchronized results for background substraction (HIGHWAY sequence)

    %1201-1400 HIGHWAY (200 frames)
    GT_PATH = '../highway/groundtruth/';
    TEST_PATH = '../results/highway/';
    list_f1_a = [];
    list_f1_b = [];
    for displacement=0:25
        total_tp_a = 0; total_fp_a = 0; total_tn_a = 0; total_fn_a = 0;
        total_tp_b = 0; total_fp_b = 0; total_tn_b = 0; total_fn_b = 0;
        for i=1201:1400
            % instead of using the corresponding ground truth frame, use a
            % de-synchronized one
            gt = imread(strcat(GT_PATH, 'gt00', int2str(i-displacement), '.png'));
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
        prec = total_tp_a/(total_tp_a+total_fp_a);
        rec = total_tp_a/(total_tp_a+total_fn_a);
        f1_a = (2*prec*rec)/(prec+rec);
        list_f1_a = [list_f1_a ; f1_a];

        prec = total_tp_b/(total_tp_b+total_fp_b);
        rec = total_tp_b/(total_tp_b+total_fn_b);
        f1_b = (2*prec*rec)/(prec+rec);
        list_f1_b = [list_f1_b ; f1_b];
    end
    plot(0:25, list_f1_a);
    hold on;
    plot(0:25, list_f1_b);
    title('Desync');
    xlabel('#desync frames')
    ylabel('F1 Score')
    legend('F1 score Test A', 'F1 score Test B');
end

