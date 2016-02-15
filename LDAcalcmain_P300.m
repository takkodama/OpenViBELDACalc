function LDAcalcmain_P300(directory_Training, directory_Trial)

%Training Files
[TargetA] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetA*.csv')]));
[TargetB] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetB*.csv')]));

%Trial Files
[Trial2clsA] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_TargetA(0.1-0.3)*.csv')]));
[Trial2clsB] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_TargetB(0.1-0.3)*.csv')]));
%{
[Trial4cls1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label1(0.1-0.3)*.csv')]));
[Trial4cls2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label2(0.1-0.3)*.csv')]));
[Trial4cls3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label3(0.1-0.3)*.csv')]));
[Trial4cls4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label4(0.1-0.3)*.csv')]));
%}

[z_A, d_A, p_targetA, b_coef_A] = LDAfuncex_P300(TargetA, TargetB, Trial2clsA);
[z_B, d_B, p_targetB, b_coef_B] = LDAfuncex_P300(TargetA, TargetB, Trial2clsB);
%{
[z_1, d_1, p_target1, b_coef_1] = LDAfuncex_SSVEP(TargetA, TargetB, Trial4cls1);
[z_2, d_2, p_target2, b_coef_2] = LDAfuncex_SSVEP(TargetA, TargetB, Trial4cls2);
[z_3, d_3, p_target3, b_coef_3] = LDAfuncex_SSVEP(TargetA, TargetB, Trial4cls3);
[z_4, d_4, p_target4, b_coef_4] = LDAfuncex_SSVEP(TargetA, TargetB, Trial4cls4);
%}

%ProbP300_2cls = horzcat(p_targetA(:,2), p_targetB(:,2));

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