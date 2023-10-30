clear; 
close all; 
clc; 

%% Parametres 
fe = 20 * 10^6;
Te = 1/fe;
Ts = 1*10^-6;
fs = 1/Ts;
Fse = Ts/Te;    
Nb = 1000; 

%Forme d'onde biphase p(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;
p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];
bk = randi([0,1],1,Nb);
len_bk = size(bk, 2);
 
% Parametres de bruit 
eb_n0_dB = 0:1:10;
eb_n0 = 10.^( eb_n0_dB /10);
Eb = max(xcorr(p));
sigA2 = 1;% Variance  théorique
sigma2 = sigA2 * Eb ./ (2 * eb_n0);
TEB = zeros(size(eb_n0));            

%% Taux d'erreur binaire 
for i = 1: length(eb_n0)
    err_cpt = 0;
    bit_cpt = 0;
    while  err_cpt  < 100

        % Modulation PPM
            sl = zeros(1, len_bk);
            for t=1:len_bk
                if(bk(1, t) == 0)
                    sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 + p;
                else
                    sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 - p;
                end
            end
          
        %% Génération  du bruit  blanc gaussien 
        nl = sqrt(sigma2(i)) * randn(1, length(sl));
        yl = sl + nl;
       
        % Reception
        rl = conv(yl,p_adapte);            
        % Echantillonage
        rm = rl(Fse:Fse:length(rl));
        %% Decision
        bits_estime = demodulate(rm);
        
        % Nbr d'erreurs binaire
        err_cpt = err_cpt + sum(~(bk == bits_estime));
        bit_cpt    = bit_cpt + length(bk);              
    end
    TEB(i) = err_cpt / bit_cpt;
end

%% Figures
pb = qfunc(sqrt (2* eb_n0));
figure();
t = 0:Te:(length(sl)-1)*Te;
semilogy(eb_n0_dB, TEB);
hold on;
semilogy(eb_n0_dB, pb);
grid on
xlabel('Eb/N0 (db)')
ylabel('TEB et Pb')
legend('Expérimentale','Theorique');
title("Simulation de TEB et Pb en fonction de Eb/N0 en db");


