function [decoded_char] = to_char(bits)
    a = bits(5:6);
    b = bits(1:4);

    decimal_value = a(1) * 2 + a(2);

    switch decimal_value
        case 0
            decoded_char = char('A' + bi2de(b) - 1);
        case 1
            decoded_char = char('P' + bi2de(b));
        case 2
            decoded_char = ' ';
        case 3
            decoded_char = char('0' + bi2de(b));
        otherwise
            decoded_char = ''; 
    end
end