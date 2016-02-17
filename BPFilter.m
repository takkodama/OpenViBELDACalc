function [AllTargetData_Filtered_P300, AllNonTargetData_Filtered_P300] = ...
    BPFilter(AllTargetData, AllNonTargetData, Electrodes)

% === Check strange signals are included or not % === 
%{
figure
title('Check strange signals are included or not ')
for i = 2:length(Electrodes)+1
    subplot(length(Electrodes),1,i-1); 
    plot([1:length(AllTargetData)], AllTargetData(:,i));
    title(char(Electrodes(i-1)));
end
%}

% === Filter % === 
Hd_P300 = Filter_P300;
for i = 1:length(Electrodes)
    AllTargetData_Filtered_P300(:, i) = filter(Hd_P300, AllTargetData(:, i));
    AllNonTargetData_Filtered_P300(:, i) = filter(Hd_P300, AllNonTargetData(:, i));
end

end