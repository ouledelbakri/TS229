function bits_estime = demodulate(rm)
    bits_estime = ones(1, length(rm));
    for i = 1:length(rm)
    
         if(rm(1, i)>0)
            bits_estime(1, i) = 0;
        else
            bits_estime(1, i) = 1;
        end
    end

end