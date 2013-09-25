
{WordArray} = require 'triplesec'

# An implementation of the normal version of CFB mode, for encryption.
#
# @param {Class} block_cipher_klass The class of the block cipher to use in CFB mode.
# @param {Buffer} key the Key to encrypt with
# @param {Buffer} plaintext the plaintext to encrypt
# @param {Buffer} iv the initial value to use for iv
# @return {Buffer} the cipher text
#
encrypt = (block_cipher_class, key, plaintext, iv) ->
  cipher = new block_cipher_class WordArray.from_buffer key 
  block_size = cipher.blockSize
  c = WordArray.from_buffer iv[0...block_size]
  pos = 0
  list = while plaintext.length > pos
    e = cipher.encryptBlock c
    c = WordArray.from_buffer plaintext[pos...(pos+block_size)]
    e.xor c, {n_words : c.words.length }
    pos += block_size
    c = e
    e.to_buffer()
  Buffer.concat list

# An implementation of the normal version of CFB mode, for decryption
#
# @param {Class} block_cipher_klass The class of the block cipher to use in CFB mode.
# @param {Buffer} key the Key to encrypt with
# @param {Buffer} ciphertext the ciphertext to decyrpt
# @param {Buffer} iv the initial value to use for iv
# @return {Buffer} the plaintext
#
decrypt = (block_cipher_class, key, ciphertext, iv) ->
  cipher = new block_cipher_class WordArray.from_buffer key
  block_size = cipher.blockSize
  iv or= new Buffer (0 for i in [0...block_size])
  b = WordArray.from_buffer iv[0...block_size]
  pos = 0
  list = while ciphertext.length > posa
    d = cipher.encryptBlock b
    b = WordArray.from_buffer ciphertext[pos...(pos+block_size)]
    d.xor b
    pos += block_size
    d.to_buffer()
  Buffer.concat list