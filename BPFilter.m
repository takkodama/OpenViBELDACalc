function [AllTargetData_Filtered_P300, AllNonTargetData_Filtered_P300] = ...
    BPFilter(AllTargetData, AllNonTargetData, Electrodes)

% === Filter % === 
Hd_P300 = Filter_P300;
for i = 1:length(Electrodes)
    AllTargetData_Filtered_P300(:, i) = filter(Hd_P300, AllTargetData(:, i));
    AllNonTargetData_Filtered_P300(:, i) = filter(Hd_P300, AllNonTargetData(:, i));
end

end