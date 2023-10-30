function [delta] = synchronisation(rl,sp)

% Calcul de la correlation croisee 
corr_croisee=xcorr(rl,sp);
len=length(corr_croisee);
taille_fenetre = 100;

corr_croisee =corr_croisee(floor(len/2)+2:floor(len/2)+101);
norm_loc =zeros(1,taille_fenetre);

% Normes de rl 
for i=1:taille_fenetre
    norm_loc(i)=norm(rl(i:i + length(sp) - 1));
end
% Estimation du decalage 
[~, delta]=max(corr_croisee / (norm_loc * norm(sp)));

end



