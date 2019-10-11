1. Replace `/etc/apt/sources.list`
2. Run
```bash
apt update
apt install -y  php7.4-cli \
                php7.4-common \
                php7.4-fpm \
                php7.4-intl \
                php7.4-json \
                php7.4-mbstring \
                php7.4-opcache \
                php7.4-pgsql \
                php7.4-readline \
                php7.4-xml \
```

3. Configure apache or nginx for fpm, an example of `nginx`
```conf
location ~ \.php$ {
  fastcgi_split_path_info ^(.+\.php)(/.+)$;
  if (!-f $document_root$fastcgi_script_name){
    return 404;
  }
  fastcgi_pass unix:/run/php/php7.4-fpm.sock;
  fastcgi_index index.php;
  include fastcgi.conf;
}

```
4. (Optional) put `tz.php` to the root of your folder to get a php panel showing system information, you need to install `hddtemp` to get disk temperature and also run `dpkg-reconfigure hddtemp` to enable daemon

