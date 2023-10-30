clc;
clear;
close all; 

%% Parametres 
fe = 20 * 10^6;
Te = 1/fe;
Ts = 1*10^-6;
fs = 1/Ts;      
Fse = Ts/Te;    
Nb = 88;

% Bits emis 
bk = randi([0,1], Nb, 1);
len_bk = size(bk, 2);
% Polynome generateur 
poly_generateur = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];

%% Signal p(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;
p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];

%% Param du bruit 
eb_n0_dB = 0:1:10;
eb_n0 = 10.^( eb_n0_dB /10);
Eb = max(xcorr(p));
sigA2 = 1;% Variance  théorique
sigma2 = sigA2 * Eb ./ (2 * eb_n0);% Variance du bruit complexe 
 
%% Codeur CRC 
crcgenerator=comm.CRCGenerator(poly_generateur); 
code=crcgenerator(bk); 
 
%% Géneration signal s_l(t) 
 
sl = []; 
for i=1:length(code)
    if code(i)==0 
        sl=[sl 0.5+p]; 
    else  
        sl=[sl 0.5-p]; 
    end 
end 
 
%% Géneration des signaux yl, rl et rm 

%yl_sans_bruit = sl;

% Generation du bruit blanc gaussien
nl = sqrt(sigma2(1)) * randn(1, length(sl));

yl = sl + nl;

rl = conv(yl, p_adapte);
rm = rl(Fse:Fse:length(rl));
 
% Decision 
bits_estime = demodulate(rm);

%% Decodeur CRC 
crc_detector = comm.CRCDetector(poly_generateur);
[~, error] = crc_detector(bits_estime');
 
 
%% Test de verification  
if error
    disp('CRC Error Detected'); 
else
    disp('No CRC Error Detected');
end
