function psnr = computePSNR(input1_s, input2_s)
% input1_s : ���
% input2_s : �g�Lfilter�_�쪺��
fpeak = double(max(max(max(input1_s))));
mse = immse(input1_s, input2_s);
psnr = 10 * log10(fpeak^2/mse);
end

