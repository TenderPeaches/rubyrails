def caesar_cipher(string = "", shift = 0)
    cipher = ""         # final cypher
    string.each_byte do |c|
        ascii_c = c.to_i
        cipher_c = ascii_c + shift
        if out_of_bounds(ascii_c)
            cipher_c = ascii_c          # don't shift non-alpha characters
        elsif overflow(ascii_c, cipher_c)
            cipher_c -= 26
        elsif underflow(ascii_c, cipher_c)
            cipher_c += 26
        end
        cipher << cipher_c
    end
    puts cipher
end

def out_of_bounds(ascii_c) 
    ascii_c < 65 || (ascii_c > 90 && ascii_c < 97) || ascii_c > 122
end

def overflow(ascii_c, cipher_c) 
    (ascii_c <= 90 && cipher_c > 90) || (ascii_c >= 97 && cipher_c > 122)
end

def underflow(ascii_c, cipher_c)
    (ascii_c <= 90 && cipher_c < 65) || (ascii_c >= 97 && cipher_c < 97)
end

caesar_cipher(ARGV[0], ARGV[1].to_i)