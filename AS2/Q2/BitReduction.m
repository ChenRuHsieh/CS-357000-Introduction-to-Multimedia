function [outputAudio] = BitReduction(inputAudio)

inputAudio_uint8 = round((inputAudio + 1) .* 2^7);
outputAudio = (inputAudio_uint8 ./ (2^7)) - 1;
end

