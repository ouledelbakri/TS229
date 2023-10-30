clc;
clear;
close all;


%% Parametres 
bk = [1, 0, 0, 1, 0];
Fe = 20 * 10e6; 
Fse = 20;
Fs = Fe/Fse;
Ts = 1/Fs;
len_bk = size(bk, 2);

% Forme d'onde biphase p(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;

p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];

%% PPM Modulation

sl = zeros(1, len_bk);
for i=1:len_bk
    if(bk(1, i) == 0)
        sl(1, (i-1)*Fse+1 : i*Fse) = 0.5 + p;
    else
        sl(1, (i-1)*Fse+1 : i*Fse) = 0.5 - p;
    end
end

%% Filre adapte 
nl = zeros(1, Fse*len_bk);
yl = sl + nl;

rl = conv(sl, p);

%% Echantionnage

rm = rl(Fse:Fse:length(rl));


%% Figures

figure(1)
plot((0:1:len_bk*Fse-1), sl)
grid on
ylabel("Amplitude")
xlabel("Temps")
title("Représentation du signal sl(t)")

figure(2)
plot(abs(rl))
grid on
ylabel("Amplitude ")
xlabel("Temps")
title('Evolution du signal rl(t)')


figure(3)
plot((Fse:Fse:len_bk*Fse), rm,'r*')
grid on
xlim ([0 Fse*(len_bk +1)])
ylabel("Amplitude ")
xlabel("n")
title("Représentation du signal échantillonné rm")


