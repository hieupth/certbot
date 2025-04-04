# Certbot image
Simple certbot image with Cloudflare DNS plugin enabled for my personal work.
## Usage
Place your Cloudflare DNS token at `cloudflare.ini` file and then run command:
```bash
docker run --rm \
  -v ./letsencrypt:/etc/letsencrypt \
  -v ./cloudflare.ini:/cloudflare.ini \
  -e DOMAINS=*.pythera.ai,pythera.ai \
  -e EMAIL=me@example.com \
  -e CLOUDFLARE_TOKEN_FILE=/cloudflare.ini \
  hieupth/certbot
```
## License
[Apache License 2.0](LICENSE).<br>
Copyright &copy; 2023 [Hieu Pham](https://github.com/hieupth). All rights reserved.