function [ output_args ] = compare_task2( input_args )
%COMPARE_TASK2 Summary of this function goes here
%   Detailed explanation goes here

% HIGHWAY (non, ad, fix-alpha); FALL (non, ad, fix-alpha) ; TRAFFIC (non, ad, fix-alpha)
y = [0.45 0.73 0.67; 0.67 0.7 0.67; 0.48 0.67 0.53];
handler = bar(y);
handler(1).FaceColor = 'b'
handler(2).FaceColor = 'g'

str = {'Highway'; 'Fall'; 'Traffic'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))

title('Adaptive vs Non-Adaptive');
xlabel('Highway');
ylabel('F1 Score');
legend('Non-Adaptive', 'Adaptive (Grid Search)', 'Adaptive (Fix Alpha)');

end

