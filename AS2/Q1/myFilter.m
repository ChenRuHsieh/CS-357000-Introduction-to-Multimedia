function [outputSignal, outputFilter] = myFilter(inputSignal, fsample, N, windowName, filterName, fcutoff)
%%% Input 
% inputSignal: input signal
% fsample: sampling frequency
% N : size of FIR filter(odd)
% windowName: 'Blackmann'
% filterName: 'low-pass', 'high-pass', 'bandpass', 'bandstop' 
% fcutoff: cut-off frequency or band frequencies
%       if type is 'low-pass' or 'high-pass', para has only one element         
%       if type is 'bandpass' or 'bandstop', para is a vector of 2 elements

%%% Ouput
% outputSignal: output (filtered) signal
% outputFilter: output filter 

%% 1. Normalization
fcutoff = fcutoff ./ fsample;
w_c = fcutoff .* (2*pi);
mid = fix(N / 2);
%% 2. Create the filter according the ideal equations (slide #76)
% (Hint) Do the initialization for the outputFilter here
% if strcmp(filterName,'?') == 1
% ...
% end
outputFilter = zeros(N , 1);
if strcmp(filterName,'low-pass') == 1
    for n = -mid : mid
        if n == 0
            outputFilter(n+mid + 1) = 2 * fcutoff;
        else
            outputFilter(n+mid + 1) = sin(w_c*n) / (pi*n);
        end
    end
elseif strcmp(filterName,'high-pass') == 1
    for n = -mid : mid
        if n == 0
            outputFilter(n+mid + 1) = 1- 2 * fcutoff;
        else
            outputFilter(n+mid + 1) = -sin(w_c*n) / (pi*n);
        end
    end 
elseif strcmp(filterName,'bandpass') == 1
    f1 = fcutoff(1);
    f2 = fcutoff(2);
    w_1 = w_c(1);
    w_2 = w_c(2);
    for n = -mid : mid
        if n == 0
            outputFilter(n+mid + 1) = 2 * (f2-f1);
        else
            outputFilter(n+mid + 1) = sin(w_2*n) / (pi*n) - sin(w_1*n) / (pi*n);
        end
    end
elseif strcmp(filterName,'bandstop') == 1
    f1 = fcutoff(1);
    f2 = fcutoff(2);
    w_1 = w_c(1);
    w_2 = w_c(2)
    for n = -mid : mid
        if n == 0
            outputFilter(n+mid + 1) = 1 - 2 * (f2-f1);
        else
            outputFilter(n+mid + 1) = sin(w_1*n) / (pi*n) - sin(w_2*n) / (pi*n);
        end
    end
else
end
%% 3. Create the windowing function (slide #79) and Get the realistic filter
% if strcmp(windowName,'Blackman') == 1 
%     % do it here
% end
if strcmp(windowName,'Blackman') == 1
    for n = 0 : N-1
        window = (0.42 - 0.5*cos((2*pi*n) / (N-1)) + 0.08*cos((4*pi*n) / (N-1)));
        outputFilter(n+1) = outputFilter(n+1) * window;
    end
end

%% 4. Filter the input signal in time domain. Do not use matlab function 'conv'
inputLen = length(inputSignal);
outputSignal = zeros(inputLen, 1);

% out[n] = sum(in[n-k]*filter[k]) ,k=0~N-1
for n = 0 : inputLen - 1
    for k = 0 : N - 1
        if n-k < 0
            in = 0;
        else
            in = inputSignal(n-k+1);
        end
        outputSignal(n+1) = outputSignal(n+1) + in * outputFilter(k+1); 
    end
end




