function [ProbP300_2cls] = LDAcalcmain_P300(directory_Training, directory_Trial)

%Training Files
%{
[TargetA] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetA*.csv')]));
[TargetB] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-classifierInput_TargetB*.csv')]));
%}
%Trial Files
%{
[Trial4cls1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label1(0.1-0.3)*.csv')]));
[Trial4cls2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label2(0.1-0.3)*.csv')]));
[Trial4cls3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label3(0.1-0.3)*.csv')]));
[Trial4cls4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-classifierTrial_Label4(0.1-0.3)*.csv')]));
%}

% === % === T r a i n i n g % === % ===
%Feature generation by signal file
[Signal_TargetA] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_TargetA*.csv')]));
[Signal_TargetB] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_TargetB*.csv')]));
[Signal_NonTargetA] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTargetA*.csv')]));
[Signal_NonTargetB] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTargetB*.csv')]));

%BandPass filtering
[Signal_TargetA_Filtered, Signal_NonTargetA_Filtered] = BPFilter(Signal_TargetA, Signal_NonTargetA, [1:8]);
[Signal_TargetB_Filtered, Signal_NonTargetB_Filtered] = BPFilter(Signal_TargetB, Signal_NonTargetB, [1:8]);

%Downsampling
[Signal_TargetA_Filtered_DS64Hz, Signal_NonTargetA_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_TargetA_Filtered, Signal_NonTargetA_Filtered, [1:8], 51);
[Signal_TargetB_Filtered_DS64Hz, Signal_NonTargetB_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_TargetB_Filtered, Signal_NonTargetB_Filtered, [1:8], 51);

Siglen = length(Signal_TargetB_Filtered_DS64Hz(:, 1));
%Epocing 64 * 0.2 = 13
for i=1:10
    Signal_TargetA_Filtered_DS64Hz_Epoc10(i, :) = Signal_TargetA_Filtered_DS64Hz((i-1)*13+1:i*13);
end

Signal_TargetB_Filtered_DS64Hz_Epoc10(i, :) = Signal_TargetB_Filtered_DS64Hz((i-1)*13+1:i*13);
Siglen = length(Signal_TargetA_Filtered_DS64Hz(:, 1));
Signal_TargetA_Filtered_DS64Hz_Epoc10 =
Signal_TargetA_Filtered_DS64Hz(1:Siglen*1/4,:)

%{
[mean(Signal_TargetA_Filtered_DS64Hz(1:Siglen*1/4,:)) mean(Signal_TargetA_Filtered_DS64Hz(Siglen*1/4+1:Siglen*2/4,:)) mean(Signal_TargetA_Filtered_DS64Hz(Siglen*2/4+1:Siglen*3/4,:)) mean(Signal_TargetA_Filtered_DS64Hz(Siglen*3/4+1:Siglen,:))]
Signal_NonTargetA_Filtered_DS64Hz_Epoc10 = [mean(Signal_NonTargetA_Filtered_DS64Hz(1:Siglen*1/4,:)) mean(Signal_NonTargetA_Filtered_DS64Hz(Siglen*1/4+1:Siglen*2/4,:)) mean(Signal_NonTargetA_Filtered_DS64Hz(Siglen*2/4+1:Siglen*3/4,:)) mean(Signal_NonTargetA_Filtered_DS64Hz(Siglen*3/4+1:Siglen,:))]
Signal_TargetB_Filtered_DS64Hz_Epoc10 = [mean(Signal_TargetB_Filtered_DS64Hz(1:Siglen*1/4,:)) mean(Signal_TargetB_Filtered_DS64Hz(Siglen*1/4+1:Siglen*2/4,:)) mean(Signal_TargetB_Filtered_DS64Hz(Siglen*2/4+1:Siglen*3/4,:)) mean(Signal_TargetB_Filtered_DS64Hz(Siglen*3/4+1:Siglen,:))]
Signal_NonTargetB_Filtered_DS64Hz_Epoc10 = [mean(Signal_NonTargetB_Filtered_DS64Hz(1:Siglen*1/4,:)) mean(Signal_NonTargetB_Filtered_DS64Hz(Siglen*1/4+1:Siglen*2/4,:)) mean(Signal_NonTargetB_Filtered_DS64Hz(Siglen*2/4+1:Siglen*3/4,:)) mean(Signal_NonTargetB_Filtered_DS64Hz(Siglen*3/4+1:Siglen,:))]
%}

%Exploit feature
[TargetA] = FeatureGenerator(Signal_TargetA_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.4, 0.1, 0.2); %EPOClength, Offset, Duration
[TargetB] = FeatureGenerator(Signal_NonTargetA_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.4, 0.1, 0.2); %EPOClength, Offset, Duration
[NonTargetA] = FeatureGenerator(Signal_TargetB_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.4, 0.1, 0.2); %EPOClength, Offset, Duration
[NonTargetB] = FeatureGenerator(Signal_NonTargetB_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.4, 0.1, 0.2); %EPOClength, Offset, Duration

% === % === T r i a l % === % ===
%Feature generation by signal file
[Signal_Trial1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label1(0.1-0.3)*.csv')]));
[Signal_Trial2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label2(0.1-0.3)*.csv')]));
[Signal_Trial3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label3(0.1-0.3)*.csv')]));
[Signal_Trial4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label4(0.1-0.3)*.csv')]));

%BandPass filtering
[Signal_Target1_Filtered, Signal_Target2_Filtered] = BPFilter(Signal_Trial1, Signal_Trial2, [1:8]);
[Signal_Target3_Filtered, Signal_Target4_Filtered] = BPFilter(Signal_Trial3, Signal_Trial4, [1:8]);

%Downsampling
[Signal_Target1_Filtered_DS64Hz, Signal_Target2_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_Target1_Filtered, Signal_Target2_Filtered, [1:8], 51);
[Signal_Target3_Filtered_DS64Hz, Signal_Target4_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_Target3_Filtered, Signal_Target4_Filtered, [1:8], 51);

%Epocing

%Exploit feature
[Trial1] = FeatureGenerator(Signal_Target1_Filtered_DS64Hz, 64, [1 5 6], 0.2, 0.0, 0.2); %EPOClength, Offset, Duration
[Trial2] = FeatureGenerator(Signal_Target2_Filtered_DS64Hz, 64, [1 5 6], 0.2, 0.0, 0.2); %EPOClength, Offset, Duration
[Trial3] = FeatureGenerator(Signal_Target3_Filtered_DS64Hz, 64, [1 5 6], 0.2, 0.0, 0.2); %EPOClength, Offset, Duration
[Trial4] = FeatureGenerator(Signal_Target4_Filtered_DS64Hz, 64, [1 5 6], 0.2, 0.0, 0.2); %EPOClength, Offset, Duration

%Discriminate to each duration
%{
Trial1_durations = [Trial1(1:5,:) Trial1(1:5,:) Trial1(1:5,:) Trial1(1:5,:)];
Trial2_durations = [Trial2(1:5,:) Trial2(1:5,:) Trial2(1:5,:) Trial2(1:5,:)];
Trial3_durations = [Trial3(1:5,:) Trial3(1:5,:) Trial3(1:5,:) Trial3(1:5,:)];
Trial4_durations = [Trial4(1:5,:) Trial4(1:5,:) Trial4(1:5,:) Trial4(1:5,:)];
%}

% === % === C a l c u l a t i o n % === % ===
[z_1, d_1, p_target1, b_coef_1] = LDAfuncex_P300(NonTargetA, TargetA, (Trial1+Trial2)/2);
%(Trial1+Trial2)/2);
%[z_2, d_2, p_target2, b_coef_2] = LDAfuncex_P300(NonTargetA, TargetA, Trial2);
[z_3, d_3, p_target3, b_coef_3] = LDAfuncex_P300(NonTargetB, TargetB, (Trial3+Trial4)/2);
%(Trial3+Trial4)/2);
%[z_4, d_4, p_target4, b_coef_4] = LDAfuncex_P300(NonTargetB, TargetB, Trial4);

%Class A & B probability
%ProbP300_2cls = horzcat((p_target1(:, 2) + p_target2(:, 2)) / 2, (p_target1(:, 2) + p_target2(:, 2)) / 2,...
%                        (p_target3(:, 2) + p_target4(:, 2)) / 2, (p_target3(:, 2) + p_target4(:, 2)) / 2);
ProbP300_2cls = [p_target1(:, 2)  p_target3(:, 2)];
ProbP300_2cls
%____________|_ Probability A _|_ Probability B _|
% Duration 1 | Correct         | Wrong
% Duration 2 | Correct         | Wrong
% Duration 3 | Wrong           | Correct
% Duration 4 | Wrong           | Correct

%{
figure
for i = 1:4
    ProbAll = ProbP300_2cls(i,:);
    
    graph(i) = subplot(2,2,i);
    DepictMatrix(ProbAll, {'Target1','Target2','Target3','Target4'}, ...
        {'P300Prob-2cls'})
        %{'SSVEPDS-4cls', 'SSVEPDS-2cls''P300DS-4cls', 'P300DS-2cls', })
end

title(graph(1), 'Discriminant Score Duration 1')
title(graph(2), 'Discriminant Score Duration 2')
title(graph(3), 'Discriminant Score Duration 3')
title(graph(4), 'Discriminant Score Duration 4')

filename_Prob = strcat(directory_Trial, '/_ResultP300Prob(LDA).png');
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