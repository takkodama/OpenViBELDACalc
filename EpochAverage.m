function [AveragedSignalArray] = EpochAverage(SignalArray, Duration_points, EpochCount)

SigLen = length(SignalArray(:, 1));
DataSet = SigLen / Duration_points / EpochCount;

for l=1:DataSet
    for k=1:EpochCount
        for i=1:Duration_points
            duration(i, :, k) = SignalArray(i+Duration_points*(k-1)+(SigLen/Duration_points)*(l-1), :);
        end
    end
    DurationArray{l} = duration;
end

AveragedSignalArray=[];
for l=DataSet:-1:1
    AveragedSignalArray = vertcat(AveragedSignalArray, mean(DurationArray{l}, 3));
end

end