function [outputAudio] = OneFoldEcho(inputAudio, fs, delay, gain)
inputLen = length(inputAudio);
offset = delay*fs;

outputAudio = zeros(inputLen, 1);
for k = 0 : inputLen-1
    if k-offset < 0
        outputAudio(k+1) = inputAudio(k+1);
    else
        outputAudio(k+1) = inputAudio(k+1) + gain * inputAudio(k-offset+1);
    end
end
outputAudio = -1 + 2 * (outputAudio - min(outputAudio)) ./ ( max(outputAudio) - min(outputAudio));
end

