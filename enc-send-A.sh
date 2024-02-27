#!/bin/bash
#Generate public and private key
openssl genrsa -out entityA_private.pem 2048
openssl rsa -pubout -in entityA_private.pem -out entityA_public.pem

#Generate symmetric key and a file with data
symmetric_key=$(openssl rand -hex 16)
echo "Some sensitive data" > data.txt

#send public and private key
scp entityA_public.pem username@ip:/path/to/destination
scp entityA_private.pem username@ip:/path/to/destination

#Generate digital signature
openssl dgst -sha256 -sign entityA_private.pem -out signature_entity1.sha256 data.txt

#Encryption
openssl enc -pbkdf2 -aes-256-cbc -in data.txt -out encrypted_data.enc -k $symmetric_key

openssl pkeyutl -encrypt -pubin -inkey entityA_public.pem -in <(echo -n "$symmetric_key") -out encrypted_symmetric_key.bin

#Send encrypted file 
scp encrypted_data.enc username@ip:/path/to/destination
scp encrypted_symmetric_key.bin username@ip:/path/to/destination

