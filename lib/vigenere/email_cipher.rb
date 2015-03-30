module VIGENERE
  class EmailCipher
    def initialize(args = {})
      @alphabet = []

      # TODO: Add any characters that need to work here
      @alphabet.concat(('a'..'z').to_a)
      @alphabet.concat(('A'..'Z').to_a)
      @alphabet.concat(('0'..'9').to_a)
      @alphabet.concat(['&','*','+','-','/','=','?','^','_','`','~','.'])
      @key = args[:key]
    end

    def cycle(length)
      @key.chars.cycle.inject('') do |str, char|
        return str if str.length == length
        str + char
      end
    end

    def alpha_encode(str)
      str = str.gsub('a','a0')
      str = str.gsub('@','a1')
      str = str.gsub('&','a2')
      str = str.gsub('*','a3')
      str = str.gsub('+','a4')
      str = str.gsub('-','a5')
      str = str.gsub('/','a6')
      str = str.gsub('=','a7')
      str = str.gsub('?','a8')
      str = str.gsub('^','a9')
      str = str.gsub('_','aa')
      str = str.gsub('`','ab')
      str = str.gsub('~','ac')
      str = str.gsub('.','ad')
      str
    end

    def alpha_decode(str)
      decoded = ''
      escaping = false
      escaped = false
      str.chars.each_with_index do |char, i|
        if escaping then
          decoded << 'a' if char == '0'
          decoded << '@' if char == '1'
          decoded << '&' if char == '2'
          decoded << '*' if char == '3'
          decoded << '+' if char == '4'
          decoded << '-' if char == '5'
          decoded << '/' if char == '6'
          decoded << '=' if char == '7'
          decoded << '?' if char == '8'
          decoded << '^' if char == '9'
          decoded << '_' if char == 'a'
          decoded << '`' if char == 'b'
          decoded << '~' if char == 'c'
          decoded << '.' if char == 'd'
          escaping = false
        elsif char == 'a' then
          escaping = true
        else
          decoded << char
        end
      end
      decoded
    end

    def encode(str)
      encoded = ''
      str = alpha_encode str
      cycled_key = cycle (str.length)
      str.chars.each_with_index do |char, i|
        cipher_index = @alphabet.find_index(cycled_key[i])
        char_index = @alphabet.find_index(char)
        enc_char_index = (char_index + cipher_index) % @alphabet.length
        enc_char = @alphabet[enc_char_index]
        encoded << enc_char
      end
      alpha_encode encoded
    end

    def decode(str)
      cycled_key = cycle str.length
      decoded = ''
      str = alpha_decode str
      str.chars.each_with_index do |char, i|
        cipher_index = @alphabet.find_index(cycled_key[i])
        char_index = @alphabet.find_index(char)
        dec_char_index = (char_index - cipher_index) % @alphabet.length
        dec_char = @alphabet[dec_char_index]
        decoded << dec_char
      end
      alpha_decode decoded
    end

    def split_addresses str
      from = str[0, str.index('_')]
      to = str[str.index('_')+1, str.length]

      addresses = { from: from, to: to }
    end

    def parse email_address
      encoded_addresses_string = email_address[0, email_address.index('@')]

      encoded_addresses = split_addresses encoded_addresses_string

      from_addr = decode(encoded_addresses[:from])
      to_addr = decode(encoded_addresses[:to])

      {from: from_addr, to: to_addr}
    end

    def create_email_address(from, to, domain)
      "#{encode(from)}_#{encode(to)}@#{domain}"
    end
  end
end
