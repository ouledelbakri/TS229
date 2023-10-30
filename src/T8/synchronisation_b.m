function [trame_adsb] = synchronisation_b(rl, sp, Fse)

    len_p=length(sp);
    
    %% Calcul de la correlation croisée 
    corr_croisee = xcorr(rl, sp);
    len=length(corr_croisee);
    corr_croisee = corr_croisee(floor(len/2)+1:end);
    
    %% Calcul de la norme de rl(t)
    norm_loc =zeros(1,length(rl));
    for i=1:length(norm_loc)-8*Fse
       norm_loc(i)=norm(rl(i:i+length(sp)-1));
    end

    %% Extraction des trames
    inter_corr=corr_croisee./(norm(sp) * norm_loc);
    cpt=1;
    for i=1:length(inter_corr)-112*Fse
        if inter_corr(i)>0.65
            trame_adsb(cpt,:)=rl(i+len_p:i+len_p+112*Fse-1);
            cpt=cpt+1;
        end 
    end

end