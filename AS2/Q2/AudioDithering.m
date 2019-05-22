function [ditheredAudio] = AudioDithering(inputAudio)
[M, N] = size(inputAudio);
ditheredAudio = zeros(M, N, 'double');
for i = 1 : M
    noise = round(255 * rand) - 127;
    if noise == 128
        noise = 1;
    else
        noise = noise / 127;
    end
    noise = noise / 127;
    ditheredAudio(i, :) = inputAudio(i, :) + noise;
end
ditheredAudio = Normalize(ditheredAudio, -1, 1);
end

