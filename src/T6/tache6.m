clc; 
clear; 
close all; 
 
addpath('../../PHY');
addpath('../../MAC')
addpath('../../General');
trame_adsb=load('../../data/adsb_msgs.mat');

for i=1:27 
    registre(i) =bit2registre(trame_adsb.adsb_msgs(:,i)');
end
longitudes = [[] registre.longitude];
latitudes = [[] registre.latitude];

%% Affichage de la carte et de la trajectoire 

affiche_carte(-0.6051667,44.8066376);
hold on 
plot(longitudes, latitudes, '--', 'Color', 'k', 'LineWidth', 2.5);

