function LDAcalcmain_P300(directory_Training, directory_Trial)

%Training Files
[TargetA] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetA*.csv')]));
[TargetB] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetB*.csv')]));

%Trial Files
[TrialA1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTest_TargetA(1)(0.1-0.3)*.csv')]));
[TrialA2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTest_TargetA(2)(0.1-0.3)*.csv')]));
[TrialB3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTest_TargetB(3)(0.1-0.3)*.csv')]));
[TrialB4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTest_TargetB(4)(0.1-0.3)*.csv')]));

[z_A1, d_A1, p_targetA1, b_coef_A1] = LDAfuncex_P300(TargetA, TargetB, TrialA1);
[z_B2, d_B2, p_targetA2, b_coef_B2] = LDAfuncex_P300(TargetA, TargetB, TrialA2);
[z_A3, d_A3, p_targetB3, b_coef_A3] = LDAfuncex_P300(TargetA, TargetB, TrialB3);
[z_B4, d_B4, p_targetB4, b_coef_B4] = LDAfuncex_P300(TargetA, TargetB, TrialB4);

ProbP300_4cls = horzcat(p_targetA1(:,2), p_targetA2(:,2), p_targetB3(:,2), p_targetB4(:,2));

%{
figure
for i = 1:4
    ProbAll = ProbSSVEP_4cls(i,:);
    
    graph(i) = subplot(2,2,i);
    DepictMatrix(ProbAll, {'Target1','Target2','Target3','Target4'}, ...
        {'P300Prob-2cls'})
        %{'SSVEPDS-4cls', 'SSVEPDS-2cls''P300DS-4cls', 'P300DS-2cls', })
end

title(graph(1), 'Discriminant Score Duration 1')
title(graph(2), 'Discriminant Score Duration 2')
title(graph(3), 'Discriminant Score Duration 3')
title(graph(4), 'Discriminant Score Duration 4')

filename_Prob = strcat(directory_Trial, '/_ResultP300Prob.png');
set(gcf,'Position', [0 0 1920 1080], 'PaperPositionMode', 'auto')
print(filename_Prob,'-dpng','-r0')
%}

end

function [AllData] = fileProcessor_dir(directory, File_dir_struct)
   
    AllData = [];
    %File_dir_struct.name
    
    for i = 1:length(File_dir_struct)
        allData_struct = importdata(strcat('./', directory, '/', File_dir_struct(i).name));
        AllData = vertcat(AllData, allData_struct.data);
    end
end