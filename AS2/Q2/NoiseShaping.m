function [noiseShapingAudio] = NoiseShaping(ditheredAudio, shapingFeedback)
[M, N] = size(ditheredAudio);
noiseShapingAudio = zeros(M, N, 'double');

for i = 1 : M
    if i == 1
        e = [0,0];
    else
        e = ditheredAudio(i-1, :) - noiseShapingAudio(i-1, :);
    end
    noiseShapingAudio(i, :) = ditheredAudio(i,:) + shapingFeedback * e;
    noiseShapingAudio(i, :) = BitReduction(noiseShapingAudio(i, :));
end
noiseShapingAudio = Normalize(noiseShapingAudio, -1, 1);


