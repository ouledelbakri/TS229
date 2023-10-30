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
Tp = 8 * 10^-6;

% Bits envoye 
bk = randi([0,1],1,Nb);
len_bk = size(bk, 2);

% Forme d'onde biphase p(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;
p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];

% Parametres de bruit 
eb_n0_dB = 0:1:10;
eb_n0 = 10.^( eb_n0_dB /10);
Eb = max(xcorr(p));
sigA2 = 1;
sigma2 = sigA2 * Eb ./ (2 * eb_n0);

%% Preambule
sp(1:1:mid) = ones(1, mid);
sp(Fse+1:1:Fse+mid) = ones(1, mid);
sp(3*Fse+mid:1:4*Fse-1) = ones(1, mid);
sp(4*Fse+mid:1:5*Fse-1) = ones(1, mid);

%%  Taux d'erreur binaire 
TEB = zeros(size(eb_n0)); 
for i = 1: length(eb_n0)
    err_cpt = 0;
    bit_cpt = 0;
    time_delay = randi(100);
    freq_delay = randi([-1e3 1e3],1,1);
    while  err_cpt  < 100

        %% Modulation PPM
        sl = zeros(1, len_bk);
        for t=1:len_bk
            if(bk(1, t) == 0)
                sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 + p;
            else
                sl(1, (t-1)*Fse+1 : t*Fse) = 0.5 - p;
            end
        end
        sl = [sp , sl];
        sl =sl.*exp(-1i*2*pi*freq_delay);

        %% Génération  du bruit  blanc gaussien complexe  
        nl = sqrt(sigma2(i)) * randn(1, length(sl)) + 1i *sqrt(sigma2(i))*randn(1, length(sl));
        yl = sl + nl;

        % yl = sl;
        % len_sp = 8*Fse;
        % for t=1+time_delay:1:time_delay+len_bk*Fse+len_sp
        %     yl(t) = nl(t)+ sl(t-time_delay) .* exp(-1j*2*pi*freq_delay*t);
        % end

        rl = abs(yl).^2;

        % considere la partie reelle 
        %rl = real(yl);
        %% Estimation du retard par methode de Synchronisation 
        delta = synchronisation(rl, sp);
        rl_syn = rl(delta+length(sp):end);
        vl = conv(rl_syn, p_adapte);
        vm = vl(Fse:Fse:length(vl));
        
        %% Decision 
        bits_estime = demodulate(vm);
        bits_estime=[bits_estime zeros(1,length(bk)-length(bits_estime))];

        % Nbr d'erreurs binaire
        err_cpt = err_cpt + sum(~(bk == bits_estime(1:length(bk))));
        bit_cpt = bit_cpt + length(bk);              
    end
    TEB(i) = err_cpt/bit_cpt;
end

%% Figures 
pb = qfunc(sqrt (2* eb_n0));
figure(1);
semilogy(eb_n0_dB, TEB);
hold on;
semilogy(eb_n0_dB, pb);
grid on
xlabel('Eb/N0 (dB)')
ylabel('TEB et Pb')
legend('Expérimentale','Theorique');
title("Evolution TEB et Pb en fonction du rapport Eb/N0 en db");
