function registre = bit2registre(bits_emis)
    
    %% Parametres
    poly_gen = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];
    lat_ref =  44.8066376;
    long_ref =  -0.6051667;
    Nz = 15;
    Nb = 17;
    
    %% Detecteur CRC
    crc_detect = comm.CRCDetector(poly_gen);
    [trame, errors] = crc_detect(bits_emis');
    trame = [zeros(1,8) trame'];
    
    % Initialisation du registre 
    registre = struct('adresse',[],'format',[],'type',[],'nom',"",'altitude',[],'latitude',[],'timeFlag',[],'cprFlag',[],'longitude',[]);

    if errors==0
        
        addresse = dec2hex(bin2dec(regexprep(num2str(trame(17:40)), '[^\w'']', '')));
        registre.format = bi2de(fliplr(trame(8:13)));
        registre.adresse = addresse;
        registre.type = bi2de(fliplr(trame(41:45)));
        
        if 0<=registre.format && registre.format<=4

            %% Nom 
            nom = zeros(1, 8);
            for i = 1:8
                char_bin = fliplr(trame((i - 1) * 6 + 49 : i * 6 + 48)); 
                nom(i) = to_char(char_bin); 
            end
            registre.nom = char(nom);
        
        elseif 9<= registre.type && registre.type <= 22 && registre.type ~= 19
           
            registre.altitude = 25*(bi2de(fliplr([trame(41:47) trame(48:52)])))-1000;

            registre.timeFlag = trame(61);
            registre.cprFlag = trame(62);
            
            %% Calcul de latitude 
            cpr = registre.cprFlag;
            Dlat = 360/(4*Nz - cpr);
            lat =bi2de(fliplr(trame(63:79)));
            j = floor(lat_ref/Dlat) + floor(0.5 + mod(lat_ref, Dlat)/Dlat - lat/(2^Nb));
          
            % Mettre a jour latitude
            latitude = Dlat * (j + lat/2^Nb);
            registre.latitude = latitude;

            %% Calcul de longitude
            if cprNL(latitude) - cpr == 0
                Dlon = 360;
            elseif cprNL(latitude)-cpr > 0
                Dlon = 360/(cprNL(latitude)-cpr);
            end
            lon = bi2de(fliplr(trame(80:96)));
            m = floor(long_ref/Dlon) + floor(0.5+mod(long_ref, Dlon)/Dlon - lon/(2^17));

            % Mettre a jour longitude
            longitude = Dlon * (m + lon/2^Nb);
            registre.longitude = longitude;

            
            
        end

    else % errors != 0
        disp("CRC error detected");
    end
end