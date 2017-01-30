function [ output_args ] = task2_2Evaluation( dataset_path,conectivity, filling)
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
%     list_se=[cellstr('diamond'), cellstr('octagon'),cellstr('square')];
%     step=100;
%     final=1000;
%     for n_se=1:size(list_se,2)
%         for opening=0:step:final
%             for R=3:3:20
%                 disp(strcat('Structral element: ',cell2mat(list_se(1,n_se)),' R: ', num2str(R), ' Opening: ',num2str(opening),' Conectivity: ',num2str(conectivity)));
%                 se = strel(cell2mat(list_se(1,n_se)),R);
                  [ prec,rec,auc]=alpha_search( INTERVALS, SEQ, dataset_path,RHO,SEQ_NAME,false, conectivity, filling, opening,true,se, false);
%             end
%         end
%     end
fig=subplot(1,1,1);
plot(rec, prec)
title(strcat('Precision Recall'));
legend(fig,strcat('Traffic - AUC ', num2str(auc)))
xlabel('Recall');
ylabel('Precision');

end

