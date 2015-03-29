require_relative '../lib/vigenere/email_cipher'

RSpec.describe VIGENERE::EmailCipher do

  def vigenere_key
    '239^83&.7t7988J*'
  end

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
    puts "key foo hello: #{VIGENERE::EmailCipher.new(key: 'foo').parse('ysGyoa7jLo5ADqsoiqCr_ysGya8o6sLfa6AuzsfrqtA@proxydomain.com')}"
    VIGENERE::EmailCipher.new(key: 'hello').decode(str)
  end

  def encoded args={}
    key = vigenere_key
    key = args[:key] if args[:key] != nil
    from = 'abc@def.com'
    from = args[:from] if args[:from] != nil
    to = 'ghi@jkl.com'
    to = args[:to] if args[:to] != nil
    ec = VIGENERE::EmailCipher.new(key: key)
    "#{ec.encode(from)}_#{ec.encode(to)}@gofundbase.com"
  end

  def encoded_reply_address args={}
    key = vigenere_key
    key = args[:key] if args[:key] != nil
    from = 'abc@def.com'
    from = args[:from] if args[:from] != nil
    to = 'ghi@jkl.com'
    to = args[:to] if args[:to] != nil
    ec = VIGENERE::EmailCipher.new(key: key)
    "#{ec.encode(to)}_#{ec.encode(from)}@gofundbase.com"
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

  describe 'create email address' do
    it 'should come up with a new email address for the receiver to reply to the sender' do
      ec = VIGENERE::EmailCipher.new(key: vigenere_key)
      expect(ec.create_email_address('ghi@jkl.com', 'abc@def.com', 'gofundbase.com')).to eq(encoded_reply_address)
    end

    it 'should be parsed correctly' do
      ec = VIGENERE::EmailCipher.new(key: vigenere_key)
      reply_addr = ec.create_email_address('ghi@jkl.com', 'abc@def.com', 'gofundbase.com')
      expect(ec.parse(reply_addr)).to eq(from: 'ghi@jkl.com', to: 'abc@def.com')
    end

    it 'should work with underscores' do
      ec = VIGENERE::EmailCipher.new(key: vigenere_key)
      reply_addr = ec.create_email_address('gh_i@jk_l.com', 'a_bc@de_f.com', 'gofundbase.com')
      expect(ec.parse(reply_addr)).to eq(from: 'gh_i@jk_l.com', to: 'a_bc@de_f.com')
    end

    it 'should work with dashes' do
      ec = VIGENERE::EmailCipher.new(key: vigenere_key)
      reply_addr = ec.create_email_address('gh-i@jk-l.com', 'a-bc@de-f.com', 'gofundbase.com')
      expect(ec.parse(reply_addr)).to eq(from: 'gh-i@jk-l.com', to: 'a-bc@de-f.com')
    end
  end

  describe 'parse email address' do
    it 'should derive the original email addresses' do
      expected = {from: 'abc@def.com', to: 'ghi@jkl.com'}
      ec = VIGENERE::EmailCipher.new(key: vigenere_key)
      expect(ec.parse(encoded)).to eq(expected)
    end
  end
end
