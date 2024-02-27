#!/bin/bash

openssl genrsa -out entityA_private.pem 2048
openssl rsa -pubout -in entityA_private.pem -out entityA_public.pem

symmetric_key=$(openssl rand -hex 16)
echo "Some sensitive data" > data.txt

scp entityA_public.pem kali@192.168.18.240:/home/kali/tasks
scp entityA_private.pem kali@192.168.18.240:/home/kali/tasks

openssl dgst -sha256 -sign entityA_private.pem -out signature_entity1.sha256 data.txt


openssl enc -pbkdf2 -aes-256-cbc -in data.txt -out encrypted_data.enc -k $symmetric_key

openssl pkeyutl -encrypt -pubin -inkey entityA_public.pem -in <(echo -n "$symmetric_key") -out encrypted_symmetric_key.bin


scp encrypted_data.enc kali@192.168.18.240:/home/kali/tasks
scp encrypted_symmetric_key.bin kali@192.168.18.240:/home/kali/tasks

