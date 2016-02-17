function [AllTargetData_Filtered_P300_DownSampled_64Hz, AllNonTargetData_Filtered_P300_DownSampled_64Hz, Duration_points_64Hz] = ...
    DownSampling(AllTargetData_Filtered_P300, AllNonTargetData_Filtered_P300, Electrodes, Duration_points)

% === Downsampling % === 

Duration_points_64Hz = ceil(Duration_points/4);

% for TARGET
for i = 1:length(Electrodes) %for 1-16Chs
    for j = 1:(length(AllTargetData_Filtered_P300)/Duration_points) %1-40 Targets
        AllTargetData_Filtered_P300_DownSampled_64Hz(1+Duration_points_64Hz*(j-1):Duration_points_64Hz*j,i) =...
            decimate(AllTargetData_Filtered_P300(1+Duration_points*(j-1):Duration_points*j, i), 4);
        %1+ceil(Duration_points/4)*(j-1)
    end
end

% for NonTARGET
for i = 1:length(Electrodes) %for 1-16Chs
    for j = 1:(length(AllNonTargetData_Filtered_P300)/Duration_points) %1-160 NonTargets
        AllNonTargetData_Filtered_P300_DownSampled_64Hz(1+Duration_points_64Hz*(j-1):Duration_points_64Hz*j,i) =...
            decimate(AllNonTargetData_Filtered_P300(1+Duration_points*(j-1):Duration_points*j, i), 4);
    end
end


end