function [SBESignalArray, DurationLen] = StimulationBasedEpoching(SignalArray, Sampling_Hz, epocSec, offsetSec, durationSec)

SigLen = length(SignalArray(:, 1)); %1020
Epoc_point = floor(epocSec * Sampling_Hz); %102
Offset_point = floor(offsetSec * Sampling_Hz); %25
Duration_point = floor(durationSec * Sampling_Hz); %51
StimulationTimes = SigLen / Epoc_point; %10
SBESignalArray = [];

for i=1:StimulationTimes
    StimulationBeginPoints(i) = (i-1)*Epoc_point+Offset_point+1;
end

for k=1:length(StimulationBeginPoints)
    for j=0:Duration_point-1
        SBESignalArray = vertcat(SBESignalArray, SignalArray(StimulationBeginPoints(k)+j, :));
    end
end

end