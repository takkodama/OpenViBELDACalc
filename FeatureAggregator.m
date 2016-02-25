function [FeatureArray] = FeatureAggregator(SignalArray, Sampling_Hz, Channels, durationSec)

SigLen = length(SignalArray(:, 1));
ChNum = length(Channels);
if(Sampling_Hz == 256), Duration_point = floor(durationSec * Sampling_Hz);
elseif(Sampling_Hz == 64), Duration_point = ceil(durationSec * Sampling_Hz);
end 
StimulationTimes = SigLen / Duration_point; %10
Dimentions = Duration_point;

FeatureArray = [];
for k=1:StimulationTimes
    for j=1:ChNum
        for i=1:Dimentions
           Feature(1, Dimentions*(j-1)+i) = SignalArray((k-1)*Dimentions+i, Channels(j));
        end
    end
    FeatureArray = vertcat(FeatureArray, Feature);
end

end