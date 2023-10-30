clc; 
clear;
close all;

%% Parametres 
fe = 20 * 10^6;
Te = 1/fe;      
Ts = 1*10^-6;
fs = 1/Ts;      
Fse = Ts/Te;    
Nb = 1000; 
Nfft = 256; 

%% Signaux p(t), p1(t) et p2(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;
p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];

% Bits d'émission 
bk = randi([0,1],1,Nb);
len_bk = size(bk, 2);

%% Modulation PPM
sl = zeros(1, len_bk);
for t=1:len_bk
    if(bk(1, t) == 0)
        sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 + p;
    else
        sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 - p;
    end
end

%% DSP Experimentale par Périodogramme de Welch 
[f, S_exp] = Mon_Welch(sl, Nfft, fe);

%% DSP analytique du signal sl(t)
S_anal = (Ts^3 * (pi*f).^2 .* (sinc(f*Ts/2).^4)) / 16;
S_anal(f == 0) = S_anal(f == 0) + 1/4;

%% Figures
figure(1)
semilogy(f,S_anal)
hold on 
semilogy(f, S_exp);
ylim([10^-15 1])
grid on
xlabel('Frequences')
ylabel('DSP')
title('Densités Spectrales de Puissance analytique et expérimentale')
legend('DSP analytique','DSP expérimentale');


