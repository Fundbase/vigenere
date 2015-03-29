require_relative '../lib/vigenere/email_cipher'

RSpec.describe VIGENERE::EmailCipher do

  def encode_trivial str
    VIGENERE::EmailCipher.new(key: 'aaaaa').encode(str)
  end

  def decode_trivial str
    VIGENERE::EmailCipher.new(key: 'aaaaa').decode(str)
  end

  def encode str
    VIGENERE::EmailCipher.new(key: 'hello').encode(str)
  end

  def decode str
    VIGENERE::EmailCipher.new(key: 'hello').decode(str)
  end

  describe 'cycle' do
    it 'should cycle until the given length' do
      expect(VIGENERE::EmailCipher.new(key: 'hello').cycle(5)).to eq('hello')
      expect(VIGENERE::EmailCipher.new(key: 'hello').cycle(20)).to eq('hellohellohellohello')
      expect(VIGENERE::EmailCipher.new(key: 'hello').cycle(3)).to eq('hel')
      expect(VIGENERE::EmailCipher.new(key: 'hello').cycle(6)).to eq('helloh')
    end
  end

  describe 'encode' do
    it 'should return a different string' do
      expect(encode 'hello').not_to eq('hello')
      expect(encode 'world').not_to eq('world')
    end

    it 'should give back the original with a trivial key' do
      expect(encode_trivial 'hello').to eq('hello')
    end

    it 'should not return 2 consecutive dots' do
      # because that is not valid in the local part of an email address
      expect(encode_trivial 'some..dots').not_to include('..')
    end

    it 'should not return starting or ending with a dot' do
      # because that is not valid in the local part of an email address
      expect(encode_trivial '.somedots.').not_to start_with('.')
      expect(encode_trivial '.somedots.').not_to end_with('.')
    end

    it 'should give back the original when trivially decoded with dots' do
      expect(decode_trivial encode_trivial 'some..dots').to eq('some..dots')
      expect(decode_trivial encode_trivial '.somedots.').to eq('.somedots.')
    end

    it 'should give back the original when trivially decoded with dots and ampersands' do
      expect(decode_trivial encode_trivial 'some&.&&.&dots').to eq('some&.&&.&dots')
    end

    it 'should give back the original when decoded' do
      expect(decode encode 'hello').to eq('hello')
      expect(decode encode 'world').to eq('world')
    end

    it 'should work for strings longer than the key' do
      expect(decode encode 'helloworldfoobar').to eq('helloworldfoobar')
    end

    it 'should work with dots' do
      expect(decode encode 'hello.world').to eq('hello.world')
    end

    it 'should work with an encoded at sign' do
      expect(decode encode '&a@hello.com').to eq('&a@hello.com')
      expect(decode encode 'hello@&a.com').to eq('hello@&a.com')
    end
  end
end
