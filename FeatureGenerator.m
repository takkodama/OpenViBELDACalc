function [FeatureArray] = FeatureGenerator(SignalArray, Sampling_Hz, Channels, epocSec, offsetSec, durationSec)

SignalLen = length(SignalArray(:, 1));
ChNum = length(Channels);
Epoc_point = floor(epocSec * Sampling_Hz);
Offset_point = floor(offsetSec * Sampling_Hz);
Duration_point = floor(durationSec * Sampling_Hz);
Term = SignalLen / Epoc_point;

for i=1:Term
    Begin_points(i) = (i-1)*Epoc_point+Offset_point+1;
end

for k=1:length(Begin_points)
    for j=1:Duration_point
        for i=1:ChNum
            FeatureArray(k, ChNum*(j-1)+i) = SignalArray(j+Begin_points(k)-1, Channels(i)); %<-should be ChNum?
        end
    end
end

end