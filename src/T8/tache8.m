clc;
clear;
close all; 

addpath('../../PHY');
addpath('../../MAC')
addpath('../../General');
buffer_enreg = load('../../data/buffers.mat');
% Recuperer les buffers 
buffer = buffer_enreg.buffers;

%% Parametres 
fe = 20 * 10^6;
Te = 1/fe;
Ds = 1e3;% Debit Symbole
Ts = 1*10^-6;
fs = 1/Ts;
Fse = Ts/Te;    
Nb = 1000; 
Tp = 8 * 10^-6;
% Les bits envoye 
bk = randi([0,1],1,Nb);
len_bk = size(bk, 2);
%Forme d'onde biphase p(t)
mid = floor(Fse/2);
p = zeros(1, Fse);
p(1:mid) = -0.5;
p(mid+1:end) = 0.5;
p_adapte = [0.5 * ones(1,mid), -0.5 * ones(1,Fse-mid)];

%% Preambule
sp(1:1:mid) = ones(1, mid);
sp(Fse+1:1:Fse+mid) = ones(1, mid);
sp(3*Fse+mid:1:4*Fse-1) = ones(1, mid);
sp(4*Fse+mid:1:5*Fse-1) = ones(1, mid);





