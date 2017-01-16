function [ output_args ] = task_1_2_3( dataset_path, task, conectivity, filling)
    
    INTERVALS=20;


    dataset_path = strcat(dataset_path, 'dataset/');
    SEQ(1,:) = [1050, 1350];
    PATH(1) = cellstr(strcat(dataset_path, 'baseline/highway/'));
    SEQ_NAME(1) = cellstr('HIGHWAY');
    RHO(1)=0.25;
    SEQ(2,:) = [1460, 1560];
    PATH(2) = cellstr(strcat(dataset_path, 'dynamicBackground/fall/'));
    SEQ_NAME(2) = cellstr('FALL');
    RHO(2)=0.052632;
    SEQ(3,:) = [950, 1050];
    PATH(3) = cellstr(strcat(dataset_path, 'cameraJitter/traffic/'));
    SEQ_NAME(3) = cellstr('TRAFFIC');
    RHO(3)= 0.157895;
    
    for dataset=1:3
        if strcmp(task,'hole') %task1
            [ prec(dataset,:),rec(dataset,:),auc(dataset)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)), false, conectivity, filling, 0,false, false);
            [ prec_old(dataset,:),rec_old(dataset,:),auc_old(dataset)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)),false, 0, false, 0,false, false);
        elseif strcmp(task,'opening') %task2
            step=100;
            final=1000;
            for opening=0:step:final
                [ prec(dataset,opening+1,:),rec(dataset,opening+1,:),auc(dataset,opening+1)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)), false, conectivity, filling, opening,false, false);
            end
        elseif strcmp(task,'morpho') %task3
            opening=0;
            [ prec(dataset,:),rec(dataset,:),auc(dataset)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)), false, conectivity, filling, opening,true, false);
        
        elseif strcmp(task,'shadow') % task4
            [ prec(dataset,:),rec(dataset,:),auc(dataset)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)), true, 0, false, 0,false, true);
            [ prec_old(dataset,:),rec_old(dataset,:),auc_old(dataset)]=alpha_search( INTERVALS, SEQ(dataset,:), cell2mat(PATH(dataset)),RHO(dataset),cell2mat(SEQ_NAME(dataset)),false, 0, false, 0,false, false);
        end
    end
    
    
    
    if strcmp(task,'hole')
        fig=subplot(1,1,1);
        hold on;
        for dataset=1:3
            plot(rec(dataset,:), prec(dataset,:))
        end
        title(strcat('Precision Recall'));
        legend(fig,strcat('Highway - AUC ', num2str(auc(1))),strcat('Fall - AUC ', num2str(auc(2))),strcat('Traffic - AUC ', num2str(auc(3))))
        xlabel('Recall');
        ylabel('Precision');
        
        disp(strcat('HIGHWAY - Conectivity: ',num2str(conectivity),' AUC: ', num2str(auc(1)),'(',num2str(auc(1)-auc_old(1)),')'));
        disp(strcat('FALL - Conectivity: ',num2str(conectivity),' AUC: ', num2str(auc(2)),'(',num2str(auc(2)-auc_old(2)),')'));
        disp(strcat('TRAFFIC - Conectivity: ',num2str(conectivity),' AUC: ', num2str(auc(3)),'(',num2str(auc(3)-auc_old(3)),')'));
    elseif strcmp(task,'opening')
         for dataset=1:3
             count=1;
             for opening=0:step:final
                 aucs(dataset, count)= auc(dataset, opening+1);
                 P(count)=opening;
                 count=count+1;
             end
         end
         fig=subplot(1,1,1);
         hold on;
         for dataset=1:3
            plot(P,aucs(dataset,:))
         end
        [maxHigh, posHigh] = max(aucs(1,:));
        [maxFall, posFall] = max(aucs(2,:));
        [maxTraffic, posTraffic] = max(aucs(3,:));
        legend(fig,strcat('Highway - Best AUC: ', num2str(maxHigh),'P: ', num2str(posHigh*step)),strcat('Fall - Best AUC: ', num2str(maxFall),'P: ', num2str(posFall*step)),strcat('Traffic - Best AUC: ', num2str(maxTraffic),'P: ', num2str(posTraffic*step)))
        xlabel('#Pixels (P)');
        ylabel('AUC');   
    elseif strcmp(task, 'shadow')
        fig=subplot(1,1,1);
        hold on;
        for dataset=1:3
            plot(rec(dataset,:), prec(dataset,:))
        end
        title(strcat('Precision Recall'));
        legend(fig,strcat('Highway - AUC ', num2str(auc(1))),strcat('Fall - AUC ', num2str(auc(2))),strcat('Traffic - AUC ', num2str(auc(3))))
        xlabel('Recall');
        ylabel('Precision');
        
        disp(strcat('HIGHWAY - AUC: ', num2str(auc(1)),'(',num2str(auc(1)-auc_old(1)),')'));
        disp(strcat('FALL -  AUC: ', num2str(auc(2)),'(',num2str(auc(2)-auc_old(2)),')'));
        disp(strcat('TRAFFIC -  AUC: ', num2str(auc(3)),'(',num2str(auc(3)-auc_old(3)),')'));
        
    end
        
end
