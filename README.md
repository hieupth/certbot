# Certbot
Docker image of [Certbot](https://certbot.eff.org) - an EFF's tool to obtain self-signed SSL certs from Let's Encrypt.
## How to use?
```
hieupth/certbot
```
This base image will obtain self-signed certs and write them to '/certs' directory followed the domain name.
#### Environments
* **CERTBOT_DOMAIN**: a space or comma separated list of domains. For example: \*.examples.com, \*.test.com.
* **CERTBOT_EMAIL**: email that you will receive updates from Let's Encrypt.
* **CERTBOT_CLOUDFLARE_TOKEN**: set this variable to your Cloudflare APIs token to process challenge.
* **CERTBOT_WEBROOT**: set this variable to the webroot path if you want to use webroot challenge.
* **CERTBOT_DEBUG**: run certbot in debug mode (dry-run) or not (default is FALSE).
* **CERTBOT_SEPARATE**: whether you want one certificate per a domain or one certificate valid for all domains (default is TRUE).
* **CERTBOT_ENCRYPT_PASS_FILE**: file of password to encrypt certs using ansible-vault.
## Use Github Actions to manage certs

## License
[Apache License 2.0](https://github.com/hieupth/certbot/blob/main/LICENSE). <br>
Copyright &copy; 2020 [Hieu Pham](https://github.com/hieupth). All rights reserved.