# Certbot
Docker image of [Certbot](https://certbot.eff.org) - an EFF's tool to obtain self-signed SSL certs from Let's Encrypt.
## How to use
There are two image to use to generate your self-signed SSL certs: 
### Basic usage
This is base image for normal usage:
```
hieupth/certbot
```
Notice that image will generate self-signed SSL certs to */certs* directory. So, you should map it to host's volume to keep generated certs.
#### Environments
* **DOMAINS**: A space or comma separated list of domains. For example: \*.examples.com,\*.test.com.
* **EMAIL**: Where you will receive updates from Let's Encrypt.
* **DEBUG**: Run certbot in debug mode (dry-run) or not (default is FALSE).
* **SEPARATE**: Whether you want one certificate per a domain or one certificate valid for all domains (default is TRUE).
* **WEBROOT**: Set this variable to the webroot path if you want to use webroot challenge.
* **CLOUDFLARE**: Set this variable to your Cloudflare APIs token to process challenge.
### SSL-encrypted
This image will encrypt all .pem files using [Ansible Vault](https://docs.ansible.com/ansible/2.8/user_guide/vault.html):
```
hieupth/certbot:encrypt
```
#### Environments
All environments are same as base image, plus:
* **PASSWORD**: encrypt password

You can use this image with Github Actions workflow to auto-generated self-signed encrypted SSL certs and keep them securely in Github repo (sample: [obtain-certs.yml](https://github.com/hieupth/certbot/blob/main/obtain-certs.yml)). 
## License
[Apache License 2.0](https://github.com/hieupth/certbot/blob/main/LICENSE). <br>
Copyright &copy; 2020 [Hieu Pham](https://github.com/hieupth). All rights reserved.