function [ProbSSVEP_2cls, ProbSSVEP_4cls] = LDAcalc_SSVEP(directory_Training, directory_Trial)

%Training Files
[Feature_Target1] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target1*.csv')]));
[Feature_Target2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target2*.csv')]));
[Feature_Target3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target3*.csv')]));
[Feature_Target4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_Target4*.csv')]));

[Feature_NonTarget1] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget1*.csv')]));
[Feature_NonTarget2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget2*.csv')]));
[Feature_NonTarget3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget3*.csv')]));
[Feature_NonTarget4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[4] SSVEP-classifierInput_NonTarget4*.csv')]));

%Trial Files
[Command1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target1*.csv')]));
[Command2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target2*.csv')]));
[Command3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target3*.csv')]));
[Command4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] SSVEP-classifierTest_Target4*.csv')]));

[z_1, d_1, p_target1, b_coef_1] = LDAfuncex_SSVEP(Feature_Target1, Feature_NonTarget1, Command1);
[z_2, d_2, p_target2, b_coef_2] = LDAfuncex_SSVEP(Feature_Target2, Feature_NonTarget2, Command2);
[z_3, d_3, p_target3, b_coef_3] = LDAfuncex_SSVEP(Feature_Target3, Feature_NonTarget3, Command3);
[z_4, d_4, p_target4, b_coef_4] = LDAfuncex_SSVEP(Feature_Target4, Feature_NonTarget4, Command4);
[z_A1, d_A1, p_targetA1, b_coef_A1] = LDAfuncex_SSVEP(vertcat(Feature_Target1, Feature_Target3), vertcat(Feature_NonTarget1, Feature_NonTarget3), Command1);
[z_B2, d_B2, p_targetB2, b_coef_B2] = LDAfuncex_SSVEP(vertcat(Feature_Target2, Feature_Target4), vertcat(Feature_NonTarget2, Feature_NonTarget4), Command2);
[z_A3, d_A3, p_targetA3, b_coef_A3] = LDAfuncex_SSVEP(vertcat(Feature_Target1, Feature_Target3), vertcat(Feature_NonTarget1, Feature_NonTarget3), Command3);
[z_B4, d_B4, p_targetB4, b_coef_B4] = LDAfuncex_SSVEP(vertcat(Feature_Target2, Feature_Target4), vertcat(Feature_NonTarget2, Feature_NonTarget4), Command4);

ProbSSVEP_4cls = horzcat(p_target1(:,2), p_target2(:,2), p_target3(:,2), p_target4(:,2));
ProbSSVEP_4cls

%____________|_ Probability 1 _|_ Probability 2 _|_ Probability 3 _|_ Probability 4 _
% Duration 1 | Correct         | Wrong           | Wrong           | Wrong           
% Duration 2 | Wrong           | Correct         | Wrong           | Wrong           
% Duration 3 | Wrong           | Wrong           | Correct         | Wrong           
% Duration 4 | Wrong           | Wrong           | Wrong           | Correct        

ProbSSVEP_2cls = horzcat((p_targetA1(:,2)+p_targetA3(:,2))/2,(p_targetB2(:,2)+p_targetB4(:,2))/2,...
                       (p_targetA1(:,2)+p_targetA3(:,2))/2,(p_targetB2(:,2)+p_targetB4(:,2))/2);
ProbSSVEP_2cls

%____________|_ Probability A _|_ Probability B _|
% Duration 1 | Correct         | Wrong
% Duration 2 | Wrong           | Correct
% Duration 3 | Correct         | Wrong
% Duration 4 | Wrong           | Correct
      
end

function [AllData] = fileProcessor_dir(directory, File_dir_struct)
   
    AllData = [];
    %File_dir_struct.name
    
    for i = 1:length(File_dir_struct)
        allData_struct = importdata(strcat('./', directory, '/', File_dir_struct(i).name));
        AllData = vertcat(AllData, allData_struct.data);
    end
end