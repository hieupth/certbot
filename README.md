# Certbot
Docker image of [Certbot](https://certbot.eff.org) - an EFF's tool to obtain self-signed SSL certs from Let's Encrypt.
## How to use
There are different images and ways to generate and use self-signed SSL certs: 
### 1. Basic Usage
```
hieupth/certbot
```
This base image will obtain self-signed certs and write them to '/certs' directory followed the domain name.
#### Environments
* **CERTBOT_DOMAINS**: A space or comma separated list of domains. For example: \*.examples.com, \*.test.com.
* **CERTBOT_EMAIL**: Where you will receive updates from Let's Encrypt.
* **CERTBOT_DEBUG**: Run certbot in debug mode (dry-run) or not (default is FALSE).
* **CERTBOT_SEPARATE**: Whether you want one certificate per a domain or one certificate valid for all domains (default is TRUE).
* **CERTBOT_WEBROOT**: Set this variable to the webroot path if you want to use webroot challenge.
* **CERTBOT_CLOUDFLARE**: Set this variable to your Cloudflare APIs token to process challenge.

### 2. Using Github Actions
```
hieupth/certbot:encrypt
```
This image will obtain self-signed certs and encrypt them by [Ansible Vault](), so we can use free Github Actions workflow (sample at [obtain.yml](https://github.com/hieupth/certbot/blob/main/obtain-certs.yml)) to generate and store certs in public repository.
#### Environments
All environments are same as base image, plus:
* **CERTBOT_ENCRYPT_PASSWORD**: encryption password
### 3. And usage at local machine 
```
hieupth/certbot:decrypt
```
This image will decrypt self-signed certs which are encrypted by hieupth/certbot:encrypt image. 
#### Environments
* **CERTBOT_ENCRYPTION_PASSWORD**: decryption password.
* **CERTBOT_SSL_REPO**: pull certs from a repo if is set. The repo will be cloned to /ssl directory and then decrypted.
## License
[Apache License 2.0](https://github.com/hieupth/certbot/blob/main/LICENSE). <br>
Copyright &copy; 2020 [Hieu Pham](https://github.com/hieupth). All rights reserved.