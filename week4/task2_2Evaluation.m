function [ output_args ] = task2_2Evaluation( dataset_path_original, dataset_path_corrected,conectivity, filling)
%TASK2_2EVALUATION Summary of this function goes here
%   Detailed explanation goes here
addpath('../week3/');
SEQ = [950, 1050];
SEQ_NAME ='TRAFFIC';
RHO= 0.157895;
opening=1000;
radius=18;
se = strel('octagon',radius);
INTERVALS=20;

morpho = true;
filling = true;
opening = 1000;
%     list_se=[cellstr('diamond'), cellstr('octagon'),cellstr('square')];
%     step=100;
%     final=1000;
%     for n_se=1:size(list_se,2)
%         for opening=0:step:final
%             for R=3:3:20
%                 disp(strcat('Structral element: ',cell2mat(list_se(1,n_se)),' R: ', num2str(R), ' Opening: ',num2str(opening),' Conectivity: ',num2str(conectivity)));
%                 se = strel(cell2mat(list_se(1,n_se)),R);
                  [prec,rec,auc]=alpha_search( INTERVALS, SEQ, dataset_path_original,RHO,SEQ_NAME,false, conectivity, filling, opening,morpho,se, false);
                  [precEs,recEs,aucEs]=alpha_search( INTERVALS, SEQ, dataset_path_corrected,RHO,SEQ_NAME,false, conectivity, filling, opening,true,se, false);
%             end
%         end
%     end
fig=subplot(1,1,1);
plot(rec, prec, recEs, precEs);
title(strcat('Precision Recall'));
legend(fig,strcat('Original - AUC ', num2str(auc)), strcat('Compensated - AUC ', num2str(aucEs)))
xlabel('Recall');
ylabel('Precision');

end

