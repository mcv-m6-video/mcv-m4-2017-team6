function [ output_args ] = task1( input_args )
%TASK1 Segmentation metrics. Understand precision & recall.
%   Implement and compute the specified measures for sequences A and B

    %1201-1400 HIGHWAY (200 frames)
    GT_PATH = '../highway/groundtruth/';
    TEST_PATH = '../results/highway/';
    for i=1201:1400
        gt = imread(strcat(GT_PATH, 'gt00', int2str(i), '.png'));
        test_a = imread(strcat(TEST_PATH, 'test_A_00', int2str(i), '.png')) > 0;
        test_b = imread(strcat(TEST_PATH, 'test_B_00', int2str(i), '.png')) > 0;
        a = 1;
    end
end

