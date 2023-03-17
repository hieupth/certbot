# Certbot Docker
[Certbot](https://certbot.eff.org) is EFF's tool to obtain self-signed SSL certs from Let's Encrypt. This repo provide a Docker image of Certbot with Cloudflare DNS plugin enabled.

## Environments
|  	|  	|  	|  	|  	|
|---	|---	|---	|---	|---	|
| DOMAINS 	| A space or comma separated list of domains 	| *.examples.com<br>*.test.com 	|  	|  	|
| EMAIL 	| Where you will receive updates from Let's Encrypt 	| mail.examples.com 	|  	|  	|
| DEBUG 	| Run certbot in debug mode (dry-run) or not 	| true<br>false 	|  	|  	|
| CONCAT 	| Whether you want to concatenate the certificate's <br>full chain with the private key (required for e.g. haproxy), <br>or keep the two files separate (required for e.g. nginx or apache). 	| true<br>false 	|  	|  	|
| SEPARATE 	| Whether you want one certificate per a domain <br>or one certificate valid for all domains. 	| true<br>false 	|  	|  	|
| WEBROOT 	| Set this variable to the webroot path if you want to use webroot challenge. 	| (string) 	|  	|  	|
| CLOUDFLARE 	| Set this variable to your Cloudflare API token to process challenge throuht Cloudflare. 	| (string) 	|  	|  	|

## License
[Apache License 2.0](https://github.com/hieupth/certbot/blob/main/LICENSE). <br>
Copyright &copy; 2020 [Hieu Pham](https://github.com/hieupth). All rights reserved.