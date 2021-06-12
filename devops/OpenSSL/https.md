# HTTPS Memo

- Secure Socket Layer(SSL) used to build trust conection between client and servers
- HTTPS (HTTP over SSL)
    - 1 client send request to server
    - 2 server send it's certification to client which include public key
    - 3 client browser use CA certificat to validate received certification
    - 4 client use received public key to encryped a session key(sysmetic key-random generated),then send to server
    - 5 server use private key to decryption get session key, then use session to encryped send ackowledgement back to client

# Certificatation
- type: DC (Domain Certificaton, get in minutes)
- type: OC (Orgnization Certification, get in 1-3 years)
- type  EC (Entendable Certification, get in 1-5 years)
- certification issued by trusted CA
- use openssl command to get CSR (certification signed Reqest), send CSR to Trusted CA
- 
 

> https://www.digitalocean.com/community/tutorials/how-to-move-an-nginx-web-root-to-a-new-location-on-ubuntu-18-04
- You can get a free certificate from Let's Encrypt by following How to Secure Nginx with Let's Encrypt on Ubuntu 18.04.
- You can also generate and configure a self-signed certificate by following How to Create a Self-signed SSL Certificate for Nginx in Ubuntu 18.04.
- You can buy one from another provider and configure Nginx to use it by following Steps 2 through 6 of  How to Create a Self-signed SSL Certificate for Nginx in Ubuntu 18.04.


## generate a self-signed SSL certificate using the OpenSSL

- Write down the Common Name (CN) for your SSL Certificate. The CN is the fully qualified name for the system that uses the certificate. If you are using Dynamic DNS, your CN should have a wild-card, for example: *.api.com. Otherwise, use the hostname or IP address set in your Gateway Cluster (for example. 192.16.183.131 or dp1.acme.com).
- Run the following OpenSSL command to generate your private key and public certificate. Answer the questions and enter the Common Name when prompted.
`openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 36500 -out certificate.pem`
-  Review the created certificate:
`openssl x509 -text -noout -in certificate.pem`
- Combine your key and certificate in a PKCS#12 (P12) bundle:
 `openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12`
- Validate your P2 file.
`openssl pkcs12 -in certificate.p12 -noout -info`