%%% HW2_Q2.m - bit reduction -> audio dithering -> noise shaping -> low-pass filter -> audio limiting -> normalization
%%% Follow the instructions (hints) and you can finish the homework

%% Clean variables and screen
clear all;close all;clc;

%% Visualization parameters (Change it if you want)
% Some Tips:
% (Tip 1) You can change the axis range to make the plotted result more clearly 
% (Tip 2) You can use subplot function to show multiple spectrums / shapes in one figure
titlefont = 15;
fontsize = 13;
LineWidth = 1.5;
sampleNum = 1000;
SHAPING_FEEDBACK = 0.99;
N = 1001;
Filter_Name = 'low-pass';
F_CUTOFF = 1000;
threshold = 0.6;
%% 1. Read in input audio file ( audioread )
[inputAudio, fs] = audioread('Tempest.wav');
startSec = 2;
endSec = startSec + sampleNum/fs;
%%% Plot the spectrum of input audio
figure(1);
[frequency, magnitude] = makeSpectrum(inputAudio, fs);
subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth);
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('Input in Frequency', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)
%%% Plot the shape of input audio
x = inputAudio;
t = 0: 1/fs: (length(x)-1)/fs;
subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth), xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Input in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('input.png');
% saveas(gca, plotName);
%% 2. Bit reduction
% (Hint) The input audio signal is double (-1 ~ 1) 
bitReductionAudio = BitReduction(inputAudio);

x = inputAudio;
t = 0: 1/fs: (length(x)-1)/fs;
figure(2);
subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Input in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

x = bitReductionAudio;
t = 0: 1/fs: (length(x)-1)/fs;
subplot(2,1,2),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('BitReduction in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('Input v.s BitReduction.png');
% saveas(gca, plotName);
%%% Save audio (audiowrite) Tempest_8bit.wav
% (Hint) remember to save the file with sampling bit = 8
audiowrite('Tempest_8bit.wav', bitReductionAudio, fs);
%% 3. Audio dithering
% (Hint) add random noise
ditheredAudio = AudioDithering(bitReductionAudio);

x = ditheredAudio;
t = 0: 1/fs: (length(x)-1)/fs;
figure(3);

subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Audio dithering in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

%%% Plot the spectrum of the dithered result
[frequency, magnitude] = makeSpectrum(ditheredAudio, fs);
subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth);%xlim([1500 20000])
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('Audio dithering in Frequency', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('Audio dithering.png');
% saveas(gca, plotName);

% audiowrite('Tempest_Dither.wav', ditheredAudio, fs);
%% 4. First-order feedback loop for Noise shaping
% (Hint) Check the signal value. How do I quantize the dithered signal? maybe scale up first?
noiseShapingAudio = NoiseShaping(ditheredAudio, SHAPING_FEEDBACK);
x = noiseShapingAudio;
t = 0: 1/fs: (length(x)-1)/fs;
figure(4);

subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Audio Noise Shaping in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

%%% Plot the spectrum of the noise shaping
[frequency, magnitude] = makeSpectrum(noiseShapingAudio, fs);
subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth);%xlim([1500 20000])
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('Audio Noise Shaping in Frequency', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('Noise Shaping Audio.png');
% saveas(gca, plotName);

figure(5);
[frequency, magnitude] = makeSpectrum(noiseShapingAudio - ditheredAudio, fs);
plot(frequency, magnitude, 'LineWidth', LineWidth);%xlim([1500 20000])
xlabel('Frequency(Hz)'),ylabel('Amplitude');  
title('NoiseShapingAudio - DitheredAudio in Frequency', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('NoiseShapingAudio - DitheredAudio.png');
% saveas(gca, plotName);

% audiowrite('Tempest_Noise_shaping.wav', noiseShapingAudio, fs);
%% 5. Implement Low-pass filter
filteredAudio = zeros(length(inputAudio),2);
outputFilter = zeros(N , 2);
[filteredAudio(:, 1), lowPassFilter1(:, 1)] = myFilter(inputAudio(:, 1), fs, N, 'Blackman', Filter_Name, F_CUTOFF);
[filteredAudio(:, 2), lowPassFilter2(:, 2)] = myFilter(inputAudio(:, 2), fs, N, 'Blackman', Filter_Name, F_CUTOFF);

figure(6);
[frequency, magnitude] = makeSpectrum(filteredAudio, fs);
plot(frequency, magnitude, 'LineWidth', LineWidth);%xlim([1500 20000])
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('filteredAudio', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('Audio after Filter in Frequency.png');
% saveas(gca, plotName);

% audiowrite('Tempest_filtered.wav', filteredAudio, fs);
%% 6. Audio limiting
limitingAudio = zeros(length(filteredAudio),2);
[limitingAudio(:, 1)] = AudioLimiting(filteredAudio(:, 1), threshold);
[limitingAudio(:, 2)] = AudioLimiting(filteredAudio(:, 2), threshold);
x = filteredAudio;
t = 0: 1/fs: (length(x)-1)/fs;

figure(7);
subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Filtered Audio in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

x = limitingAudio;
t = 0: 1/fs: (length(x)-1)/fs;

subplot(2,1,2),plot(t, x, 'LineWidth', LineWidth);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Audio Limiting in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('LimitingAudio.png');
% saveas(gca, plotName);
%% 7. Normalization
recoverAudio = Normalize(limitingAudio, -1, 1);


%% 8. Save audio (audiowrite) Tempest_Recover.wav
%recoverAudio = BitReduction(recoverAudio);
audiowrite('Tempest_Recover.wav', recoverAudio, fs);


%%% Plot the spectrum of output audio
x = recoverAudio;
t = 0: 1/fs: (length(x)-1)/fs;
figure(8);

subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth)%,xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Recover Audio in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)


%%% Plot the shape of output audio
[frequency, magnitude] = makeSpectrum(recoverAudio, fs);
subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth);%xlim([1500 20000])
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('Recover Audio in Frequence', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

plotName = sprintf('Recover Audio.png');
% saveas(gca, plotName);

figure(9);
x = Normalize(inputAudio,-1,1);
t = 0: 1/fs: (length(x)-1)/fs;
subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth)%,xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Input Audio in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

x = recoverAudio;
t = 0: 1/fs: (length(x)-1)/fs;
subplot(2,1,2),plot(t, x, 'LineWidth', LineWidth)%,xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Recover Audio in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

% plotName = sprintf('Input v.s Recover.png');
% saveas(gca, plotName);