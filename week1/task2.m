function [ ] = task2()
%TASK2 Segmentation metrics. Temporal analysis.
%   Temporal analysis of the results

    %1201-1400 HIGHWAY (200 frames)
    GT_PATH = '../highway/groundtruth/';
    TEST_PATH = '../results/highway/';
    % store frame results here
    list_tp_a = [];
    list_tp_b = [];
    list_fg = [];
    list_f1_a = [];
    list_f1_b = [];
    
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
        prec_a = tp_a/(tp_a+fp_a);
        rec_a = tp_a/(tp_a+fn_a);
        if (prec_a+rec_a > 0)
            f1_a = (2*prec_a*rec_a)/(prec_a+rec_a);
        else
            f1_a = 0;
        end
        
        % results for test_B
        tp_b = sum(test_b(gt_mask)); % True Positive
        fp_b = sum(test_b(~gt_mask)); % False Positive
        tn_b = sum(~test_b(~gt_mask)); % True Negative
        fn_b = sum(~test_b(gt_mask)); % False Negative
        prec_b = tp_b/(tp_b+fp_b);
        rec_b = tp_b/(tp_b+fn_b);
        if (prec_b+rec_b > 0)
            f1_b = (2*prec_b*rec_b)/(prec_b+rec_b);
        else
            f1_b = 0;
        end
        
        % Store the results of this frame
        list_tp_a = [list_tp_a ; tp_a];
        list_tp_b = [list_tp_b ; tp_b];
        list_fg = [list_fg ; sum(gt_mask(:))];
        list_f1_a = [list_f1_a ; f1_a];
        list_f1_b = [list_f1_b ; f1_b];
    end
    figure
    plot(list_fg);
    hold on;
    plot(list_tp_a);
    plot(list_tp_b);
    title('Graph 1');
    xlabel('frame')
    ylabel('TP')
    legend('Total Foreground','TP Test A', 'TP Test B');
    
    waitforbuttonpress;
    clf
    hold off;
    
    plot(list_f1_a);
    hold on;
    plot(list_f1_b);
    title('Graph 2');
    xlabel('frame')
    ylabel('F1 Score')
    legend('F1 score Test A', 'F1 score Test B');
    
end

