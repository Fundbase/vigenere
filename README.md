# vigenere

This is a simple gem for encoding email addresses with a vigenere cipher in a way that can be decoded later.

It can create an email address that contains an encoded version of the from and to email addresses. Then it can also parse such an address to later retrieve the original from and to addresses.

The key tells how much to rotate each letter by, so the trivial key 'a' (or 'aaaa', etc.) will not rotate at all and the encoded version will match the original.

## Encoding

Use the ```encode``` method to encode with the cipher.

```
VIGENERE::EmailCipher.new(key: 'foo').encode('hello')
```

## Decoding

Use ```decode``` to decode an encoded string to get the original

```
VIGENERE::EmailCipher.new(key: 'foo').decode('mszqC')
```

## Encoding a pair of email addresses

Use ```create_email_address``` to create an email address that contains the original 2 email addresses encoded with the vigenere cipher. It takes the from address, the to address, and the domain as arguments.

```
VIGENERE::EmailCipher.new(key: 'foo').create_email_address('test@example.com','test2@example.com','proxydomain.com')
```

This will generate ```ysGyoa7jLo5ADqsoiqCr_ysGya8o6sLfa6AuzsfrqtA@proxydomain.com```

## Getting the original pair of email addresses back

Then when we have an encoded email address like this, we can parse it for the original addresses with ```parse```

```
VIGENERE::EmailCipher.new(key: 'foo').parse('ysGyoa7jLo5ADqsoiqCr_ysGya8o6sLfa6AuzsfrqtA@proxydomain.com')
```

This will return a hash like this: ```{:from=>"test@example.com", :to=>"test2@example.com"}```
