%%% HW2_Q1.m - Complete the procedure of separating HW2_mix.wav into 3 songs

%% Clean variables and screen
close all;
clear;
clc;

%% Visualization parameters (Change it if you want)
% Some Tips:
% (Tip 1) You can change the axis range to make the plotted result more clearly 
% (Tip 2) You can use subplot function to show multiple spectrums / shapes in one figure
titlefont = 15;
fontsize = 13;
LineWidth = 1.5;
sampleNum = 1000;
startF = 0;
endF = 1200;
Condition = ["low-pass",1001,350,-1;"high-pass",1001,800,-1;"bandpass",1001,420,650];
%% 1. Read in input audio file ( audioread )
% inputAudio: input signal, fs: sampling rate
[inputAudio, fs] = audioread('HW2_Mix.wav');
startSec = 8;
endSec = startSec + sampleNum/fs;

%%% Plot example : plot the input audio
% The provided function "make_spectrum" generates frequency
% and magnitude. Use the following example to plot the spectrum.
x = inputAudio;
t = 0: 1/fs: (length(x)-1)/fs;
figure(1);
subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
xlabel('Time (seconds)'),ylabel('Amplitude');
title('Input in Time', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

[frequency, magnitude] = makeSpectrum(inputAudio, fs);
subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth),xlim([startF endF]);
xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
title('Input in Frequency', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)
plotName = sprintf('input.png');
% % saveas(gca, plotName);
for i = 1:3
    endSec = startSec + sampleNum/fs;
%% 2. Filtering 

    % (Hint) Implement my_filter here
    % [...] = myFilter(...);
    Filter_Name = Condition(i,1);
    N = str2double(Condition(i,2));
    F_CUTOFF = str2double(Condition(i,3:4));
    F_CUTOFF(find(F_CUTOFF==-1)) = [];
    
    [outputAudio, my_filter] = myFilter(inputAudio, fs, N, 'Blackman', Filter_Name, F_CUTOFF);

    %%% Plot the shape of filters in Time domain
    figure(2);
    x = my_filter;
    t = 0: 1/fs: (length(x)-1)/fs;
    subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth);
    xlabel('Time (seconds)'),ylabel('Amplitude');
    title('Filter in Time', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    
    %%% Plot the spectrum of filters (Frequency Aysis)
    [frequency, magnitude] = makeSpectrum(my_filter, fs);
    subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth),xlim([startF endF]);
    xlabel('Frequency(Hz)'),ylabel('Amplitude');
    title('Filter in Frequency', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    
    if length(F_CUTOFF) == 1
        plotName = sprintf('%s_%d.png', Filter_Name,F_CUTOFF);
    elseif length(F_CUTOFF) == 2
        plotName = sprintf('%s_%d_%d.png', Filter_Name, F_CUTOFF(1), F_CUTOFF(2));
    end
    % saveas(gca, plotName);
    
    %% 3. Save the filtered audio (audiowrite)
    % Name the file 'FilterName_para1_para2.wav'
    % para means the cutoff frequency that you set for the filter
    if length(F_CUTOFF) == 1
        File_Name = sprintf('%s_%d.wav', Filter_Name, F_CUTOFF);
    elseif length(F_CUTOFF) == 2
        File_Name = sprintf('%s_%d_%d.wav', Filter_Name, F_CUTOFF(1), F_CUTOFF(2));    
    end
    audiowrite(File_Name, outputAudio, fs);
    % audiowrite('FilterName_para1_para2.wav', output_signal1, fs);

    %%% Plot the spectrum of filtered signals
    x = outputAudio;
    t = 0: 1/fs: (length(x)-1)/fs;
    figure(3);
    subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
    xlabel('Time (seconds)'),ylabel('Amplitude');
    title('Output in Time', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)

    [frequency, magnitude] = makeSpectrum(outputAudio, fs);
    subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth),xlim([startF endF])
    xlabel('Frequency(Hz)'),ylabel('Amplitude'); 
    title('Output in Frequency', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    
    if length(F_CUTOFF) == 1
        plotName = sprintf('outputSignal_%s_%d.png', Filter_Name,F_CUTOFF);
    elseif length(F_CUTOFF) == 2
        plotName = sprintf('outputSignal_%s_%d_%d.png', Filter_Name, F_CUTOFF(1), F_CUTOFF(2));
    end
    % saveas(gca, plotName);
    
    %% 4, Reduce the sample rate of the three separated songs to 2kHz.
    [P,Q] = rat(2e3/fs); %% get the ratio of 2K and 44100
    fnew = (P/Q*fs);
    outputAudio2K = resample(outputAudio,P,Q);
    
    figure(4);
    x = outputAudio;t = 0: 1/fs: (length(x)-1)/fs;
    subplot(2,1,1),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
    xlabel('Time (seconds)'),ylabel('Amplitude');
    title('Output 44100Hz', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    x = outputAudio2K;t = 0: 1/fnew: (length(x)-1)/fnew;
    subplot(2,1,2),plot(t, x, 'LineWidth', LineWidth),xlim([startSec endSec]);
    xlabel('Time (seconds)'),ylabel('Amplitude');
    title('Output 2kHz', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    
    if length(F_CUTOFF) == 1
        plotName = sprintf('outputSignal_%s_%d_%dHz.png', Filter_Name,F_CUTOFF, fnew);
    elseif length(F_CUTOFF) == 2
        plotName = sprintf('outputSignal_%s_%d_%d_%dHz.png', Filter_Name, F_CUTOFF(1), F_CUTOFF(2), fnew);
    end
    % saveas(gca, plotName);
    
    %{
    figure(4);
    [frequency, magnitude] = makeSpectrum(outputAudio, fs);
    subplot(2,1,1),plot(frequency, magnitude, 'LineWidth', LineWidth); 
    title('Output441 in Frequency', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)

    [frequency, magnitude] = makeSpectrum(outputAudio4K, fnew);
    subplot(2,1,2),plot(frequency, magnitude, 'LineWidth', LineWidth); 
    title('Output4K in Frequency', 'fontsize', titlefont);
    set(gca, 'fontsize', fontsize)
    %}

    %% 4. Save the files after changing the sampling rate
    if length(F_CUTOFF) == 1
        File_Name = sprintf('%s_%d_2kHz.wav', Filter_Name, F_CUTOFF);
    elseif length(F_CUTOFF) == 2
        File_Name = sprintf('%s_%d_%d_2kHz.wav', Filter_Name, F_CUTOFF(1), F_CUTOFF(2));    
    end
    audiowrite(File_Name, outputAudio2K, fnew);

    if i == 1
        %% 5. one-fold echo and multiple-fold echo (slide #69)
        delay = 0.2;
        gain = 0.5;
        outputAudioOneFoldEcho  = OneFoldEcho(outputAudio, fs, delay, gain);
        outputAudioMutiFoldEcho = MutiFoldEcho(outputAudio, fs, delay, -gain);
        
        figure(5);
        x1 = outputAudioOneFoldEcho;
        x2 = outputAudioMutiFoldEcho;
        t = 0: 1/fs: (length(x1)-1)/fs;
        endSec = startSec + 5e4/fs;
        plot(t, x2, t, x1, 'LineWidth', LineWidth)%,xlim([startSec endSec]);
        % plot(t, x2-x1, 'LineWidth', LineWidth)%,xlim([startSec endSec]);
        xlabel('Time (seconds)'),ylabel('Amplitude');
        title('One Fold Echo v.s. Muti Fold Echo', 'fontsize', titlefont);
        set(gca, 'fontsize', fontsize)
        %% 6. Save the echo audios  'Echo_one.wav' and 'Echo_multiple.wav'
        audiowrite('Echo_one.wav'     , outputAudioOneFoldEcho , fs);
        audiowrite('Echo_multiple.wav', outputAudioMutiFoldEcho, fs);
          
        plotName = sprintf('Echo.png');
        % saveas(gca, plotName);
        
    end
end
