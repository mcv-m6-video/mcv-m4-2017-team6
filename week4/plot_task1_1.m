function [ output_args ] = plot_task1_1( )
%PLOT_TASK1_1 Summary of this function goes here
%   Detailed explanation goes here

    load('task1_1_results/seq_45_fwd.mat');
    
    b_sizes = [8 16 24 32 40 48];
    areas = [8 16 24 32 40 48];
    
    figure;
    hold on;
    
    for bi = 1:length(b_sizes)
       block_results = results((bi-1)*6+1:bi*6,2);
       plot(areas, block_results, 'DisplayName', sprintf('Block size: %i',b_sizes(bi)))
       ylabel('PPEN')
       xlabel('Area of Search')
       set(gca, 'XTick', areas);
    end
    legend('show');
    
%     b_8 = results(1:6,2);
%     b_16 = results(7:12,2);
%     b_24 = results(13:18,2);
%     b_32 = results(19:24,2);
%     b_40 = results(25:30,2);
%     b_48 = results(31:36,2);
end

