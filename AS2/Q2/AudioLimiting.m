function [limitingAudio] = AudioLimiting(inputAudio, threshold)
[M, N] = size(inputAudio);
limitingAudio = zeros(M, N, 'double');

for i = 1 : M
    if inputAudio(i) > threshold
        limitingAudio(i) = threshold;
    elseif inputAudio(i) < -threshold
        limitingAudio(i) = -threshold;
    else
        limitingAudio(i) = inputAudio(i);
    end
end
end

