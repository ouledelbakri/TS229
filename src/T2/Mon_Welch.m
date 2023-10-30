function [f, S_exp] = Mon_Welch(x, Nfft, Fe)
 
    len_x = size(x,2);
    nbr_ech = floor(len_x/Nfft);
    Per = zeros(nbr_ech, Nfft);
    
    for i=0:1:nbr_ech-1
        Per(i+1, 1:1:Nfft) = abs(fftshift(fft(x(1, i*Nfft+1:1:(i+1)*Nfft), Nfft))).^2;
    end
    
    % Peridogramme de Welch 
    S_exp = mean(Per) ./(Nfft *Fe);
    % Frequences 
    f = -Fe/2+Fe/Nfft:Fe/Nfft:Fe/2;
    
end