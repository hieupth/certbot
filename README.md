# Certbot
Docker image of [Certbot](https://certbot.eff.org) - an EFF's tool to obtain self-signed SSL certs from Let's Encrypt.
## Images
There is two different image:
### Base
This is base image which can obtain self-signed SSL certs as standalone, webroot or cloudflare DNS:
```
docker pull hieupth/certbot
```
#### Environments
* **DOMAINS**: A space or comma separated list of domains. For example: \*.examples.com,\*.test.com.
* **EMAIL**: Where you will receive updates from Let's Encrypt.
* **DEBUG**: Run certbot in debug mode (dry-run) or not (default is FALSE).
* **SEPARATE**: Whether you want one certificate per a domain or one certificate valid for all domains (default is TRUE).
* **WEBROOT**: Set this variable to the webroot path if you want to use webroot challenge.
* **CLOUDFLARE**: Set this variable to your Cloudflare APIs token to process challenge.
### Ansible-vault encrypted
This image will encrypt all .pem files using ansible-vault:
```
docker pull hieupth/certbot:ansvault
```
#### Environments
Same as base image plus:
* **PASSWORD**: encrypt password

## License
[Apache License 2.0](https://github.com/hieupth/certbot/blob/main/LICENSE). <br>
Copyright &copy; 2020 [Hieu Pham](https://github.com/hieupth). All rights reserved.