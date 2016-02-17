function [ProbSSVEP_2cls, ProbSSVEP_4cls] = LDAcalcmain_SSVEP(directory_Training, directory_Trial)

%Training Files
[Target1] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target1*.csv')]));
[Target2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target2*.csv')]));
[Target3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target3*.csv')]));
[Target4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target4*.csv')]));

[NonTarget1] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget1*.csv')]));
[NonTarget2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget2*.csv')]));
[NonTarget3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget3*.csv')]));
[NonTarget4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget4*.csv')]));

%Trial Files
[Freq1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target1*.csv')]));
[Freq2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target2*.csv')]));
[Freq3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target3*.csv')]));
[Freq4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target4*.csv')]));

[z_1, d_1, p_target1, b_coef_1] = LDAfuncex_SSVEP(Target1, NonTarget1, Freq1);
[z_2, d_2, p_target2, b_coef_2] = LDAfuncex_SSVEP(Target2, NonTarget2, Freq2);
[z_3, d_3, p_target3, b_coef_3] = LDAfuncex_SSVEP(Target3, NonTarget3, Freq3);
[z_4, d_4, p_target4, b_coef_4] = LDAfuncex_SSVEP(Target4, NonTarget4, Freq4);
[z_A1, d_A1, p_targetA1, b_coef_A1] = LDAfuncex_SSVEP(vertcat(Target1, Target3), vertcat(NonTarget1, NonTarget3), Freq1);
[z_B2, d_B2, p_targetB2, b_coef_B2] = LDAfuncex_SSVEP(vertcat(Target2, Target4), vertcat(NonTarget2, NonTarget4), Freq2);
[z_A3, d_A3, p_targetA3, b_coef_A3] = LDAfuncex_SSVEP(vertcat(Target1, Target3), vertcat(NonTarget1, NonTarget3), Freq3);
[z_B4, d_B4, p_targetB4, b_coef_B4] = LDAfuncex_SSVEP(vertcat(Target2, Target4), vertcat(NonTarget2, NonTarget4), Freq4);

ProbSSVEP_4cls = horzcat(p_target1(:,2), p_target2(:,2), p_target3(:,2), p_target4(:,2));
ProbP300_4cls

%____________|_ Probability 1 _|_ Probability 2 _|_ Probability 3 _|_ Probability 4 _
% Duration 1 | Correct         | Wrong           | Wrong           | Wrong           
% Duration 2 | Wrong           | Correct         | Wrong           | Wrong           
% Duration 3 | Wrong           | Wrong           | Correct         | Wrong           
% Duration 4 | Wrong           | Wrong           | Wrong           | Correct        

ProbSSVEP_2cls = horzcat((p_targetA1(:,2)+p_targetA3(:,2))/2,(p_targetB2(:,2)+p_targetB4(:,2))/2,...
                       (p_targetA1(:,2)+p_targetA3(:,2))/2,(p_targetB2(:,2)+p_targetB4(:,2))/2);
ProbP300_2cls

%____________|_ Probability A _|_ Probability B _|
% Duration 1 | Correct         | Wrong
% Duration 2 | Wrong           | Correct
% Duration 3 | Correct         | Wrong
% Duration 4 | Wrong           | Correct
                   
figure
for i = 1:4
    ProbAll = vertcat(ProbSSVEP_4cls(i,:), ProbSSVEP_2cls(i,:));
    
    graph(i) = subplot(2,2,i);
    DepictMatrix(ProbAll, {'Target1','Target2','Target3','Target4'}, ...
        {'SSVEPProb-4cls', 'SSVEPProb-2cls'})
        %{'SSVEPDS-4cls', 'SSVEPDS-2cls''P300DS-4cls', 'P300DS-2cls', })
end

title(graph(1), 'Discriminant Score Duration 1')
title(graph(2), 'Discriminant Score Duration 2')
title(graph(3), 'Discriminant Score Duration 3')
title(graph(4), 'Discriminant Score Duration 4')

filename_Prob = strcat(directory_Trial, '/_ResultSSVEPProb(LDA).png');
set(gcf,'Position', [0 0 1920 1080], 'PaperPositionMode', 'auto')
print(filename_Prob,'-dpng','-r0')


end

function [AllData] = fileProcessor_dir(directory, File_dir_struct)
   
    AllData = [];
    %File_dir_struct.name
    
    for i = 1:length(File_dir_struct)
        allData_struct = importdata(strcat('./', directory, '/', File_dir_struct(i).name));
        AllData = vertcat(AllData, allData_struct.data);
    end
end