#!/bin/bash

#Decryption
openssl pkeyutl -decrypt -inkey entityA_private.pem -in encrypted_symmetric_key.bin -out decrypted_symmetric_key.txt

openssl enc -pbkdf2 -aes-256-cbc -d -in encrypted_data.enc -out decrypted_data.txt -k $(cat decrypted_symmetric_key.txt)
