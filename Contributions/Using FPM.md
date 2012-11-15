This is a step-by-step guide to set up PHP-FPM to work with OS X built-in Apache. The following assumes that you are familiar with configuring Apache and you know what PHP-FPM is. In short, PHP-FPM allows you to decouple PHP and your web server, by running PHP instances in separate processes. This has several benefits, including improved performance, robustness (bugs in PHP do not crash the whole web server) and flexibility (e.g., interfacing with Apache and Nginx). Another advantage, especially for local development, is that PHP may run as your user (which is the default for a “standard” Homebrew), so that files written by web applications will be owned by you, and not by `_www`. See http://php-fpm.org/ for more information. The following setup has been tested on Snow Leopard and Lion, and has been used for development for more than one year without any problem.

## Quick summary

0. `brew update && brew pull https://github.com/mxcl/homebrew/pull/12093`
1. `brew install mod_fastcgi`
2. Read caveats
3. `brew install php54 --with-fpm`
4. Read caveats
5. `launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist`
6. Create a properly configured virtual host (see below)
7. Restart Apache

If you are using PHP 5.3.x, just replace all occurrences of “php54” with “php53” in the instructions.

## Configuring OS X Apache

No special configuration is needed in Apache, as OS X Apache works out of the box. But for serious work, you will almost certainly need name-based virtual hosts. This section explains how to enable (SSL) name-based virtual hosts: feel free to skip it if your web server already supports them or you do not bother to enable that feature.

### Name-based virtual hosts

1. Disable Apache in System Preferences > Sharing.
2. Edit `/etc/apache2/httpd.conf` (copy it from `httpd.conf.default` if it does not exist) and uncomment the line:

```
    Include /private/etc/apache2/extra/httpd-vhosts.conf
```
3. Edit /etc/apache2/extra/http-vhosts.conf and comment out all dummy virtual hosts. Define the default virtual host as follows:

```
    <VirtualHost *:80>
      DocumentRoot "/Library/WebServer/Documents"
      ServerName localhost
    </VirtualHost>`
```

And add a directive similar to the following:

```
    Include /etc/apache2/vhosts/*.conf
```

The above will be the directory where virtual host configuration files will go. The path is arbitrary, but it must exist. In this example, all virtual hosts configuration files are assumed to be in /etc/apache2/vhosts.

4. Save http-vhosts.conf and test that the configuration is fine by executing `apachectl configtest`.

### SSL name-based virtual hosts

**Note:** SSL name-based virtual hosts require Apache 2.2.12 or greater and OpenSSL 0.9.8f or greater.

Edit /etc/apache2/extra/httpd-ssl.conf and, under the “SSL Virtual Host Context” section, add the following:

```
    NameVirtualHost *:443
    SSLStrictSNIVHostCheck off
```
and replace `<VirtualHost _default_:443>` with `<VirtualHost *:443>`.

Test the configuration with `apachectl configtest`, then restart Apache. If all is fine, in the Apache's error log (which you can access from the Console app) you should read the following message:

```
    [warn] Init: Name-based SSL virtual hosts only work for clients with TLS server name indication support (RFC 4366)
```

## Enabling support for FastCGI

For PHP-FPM to work with OS X built-in Apache, you need to install mod_fastcgi. There is a formula for that at https://github.com/mxcl/homebrew/pull/12093 (hopefully, soon within Homebrew).

To install the formula, type the following commands:

```
    brew pull https://github.com/mxcl/homebrew/pull/12093
    brew install mod_fastcgi
```

Then follow the onscreen instructions to configure Apache to use mod_fastcgi.

## Installing Homebrew's PHP with support for PHP-FPM

Refer to https://github.com/josegonzalez/homebrew-php. You will need to add --with-fpm when you install the formula, e.g.

```
    brew install php54 --with-fpm
```

## Configuring PHP-FPM

PHP-FPM's configuration file is located at $HOMEBREW_PREFIX/etc/php/5.4/php-fpm.conf. The default configuration is fine for most purposes, but you may want to edit it to suit your needs. For example, some parameters you may want to tune are `pm.start_servers` (number of child processes at startup), `pm.max_spare_servers` (maximum number of idle server processes), `pm.max_requests` (maximum number of requests each child process should execute before respawning), etc…

If you want PHP-FPM to listen on a Unix socket instead of a TCP socket (see the virtual host configuration below), which is faster when the web server and PHP-FPM are on the same machine, you must change `listen = 127.0.0.1:9000` to `listen = /tmp/php-fpm.sock` in php-fpm.conf.

## Testing PHP-FPM with Apache

You may check that PHP-FPM is configured correctly by running the following:

```
    php-fpm -y $HOMEBREW_PREFIX/etc/php/5.4/php-fpm.conf -t
```

You are now ready to make your first virtual host using PHP-FPM! Create an Apache virtual host configuration file in /etc/apache2/vhosts (or wherever your virtual host configuration files should be located), whose content will be similar to the following:

```
    <VirtualHost *:80>
      ServerName HOSTNAME
      DocumentRoot /Library/WebServer/HOSTNAME

      <Directory "/Library/WebServer/HOSTNAME">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>

      # Ensure that mod_php5 is off
      <IfModule mod_php5.c>
          php_admin_flag engine off
      </IfModule>

      <IfModule mod_fastcgi.c>
          AddHandler php-fastcgi .php
          Action php-fastcgi /php-fpm
          Alias /php-fpm /Library/WebServer/HOSTNAME.fcgi
          # If PHP-FPM is configured to listen on a Unix socket, use this:
          FastCGIExternalServer /Library/WebServer/HOSTNAME.fcgi -socket /tmp/php-fpm.sock
          # Otherwise, use this:
          #FastCGIExternalServer /Library/WebServer/HOSTNAME.fcgi -host 127.0.0.1:9000

          # Without the following directive, you'll get an Access Forbidden error
          # when the path aliased by /php-fpm is not under the document root:
          <Location /php-fpm>
              Order Deny,Allow
              Deny from all
              Allow from env=REDIRECT_STATUS
          </Location>
      </IfModule>
    </VirtualHost>
```

The above assumes that virtual hosts are inside directories under /Library/WebServer: change this path according to your needs (for example, I keep my virtual hosts under /Users/lifepillar/VirtualHosts). Replace HOSTNAME with the host name. Note that **HOSTNAME.fcgi does not have to exist**. The FastCGIExternalServer directive forwards all the requests hitting /Library/WebServer/HOSTNAME.fcgi to the external application (php-fpm, in this case) via a socket (unix or tcp).

Create the /Library/WebServer/HOSTNAME folder and throw some PHP script in it. A file called info.php with the following content will do:

```php
    <?php phpinfo() ?>
```

Do not forget to add the virtual host to /etc/hosts. Edit /etc/hosts and add the following line:

```
    127.0.0.1   HOSTNAME
```

Start php-fpm directly from the command line (for debugging):

```
    php-fpm --fpm-config $HOMEBREW_PREFIX/etc/php/5.4/php-fpm.conf
```

Then restart Apache to enable the virtual host. Keep an eye on the Apache error log through the Console app to ensure that there are no errors. Then visit http://HOSTNAME/info.php. If all is fine, you should see a page of information about PHP. In the “Server API” field, you should read “FPM/FastCGI”.

If all is fine, you may kill php-fpm and launch it as a launchd daemon. Since PHP and Apache are now decoupled, you may start/stop/update the web server and PHP independently.

For the sake of completeness, here is a corresponding configuration file for HTTPS (this assumes that you have enabled SSL name-based virtual hosting as explained at the beginning of this document):

```
    <VirtualHost *:443>
      ServerName HOSTNAME
      DocumentRoot /Library/WebServer/HOSTNAME

      <Directory "/Library/WebServer/HOSTNAME">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>

      <IfModule php5_module>
        php_admin_flag engine off
      </IfModule>

      <IfModule mod_fastcgi.c>
        AddHandler php-fastcgi .php
        Action php-fastcgi /php-fpm
        Alias /php-fpm /Library/WebServer/HOSTNAME.fcgi
      </IfModule>

      <Location /php-fpm>
        Order Deny,Allow
        Deny from all
        Allow from env=REDIRECT_STATUS
      </Location>

      # From here, standard SSL-related stuff
      SSLEngine on
      SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
      SSLCertificateFile "/etc/apache2/certs/HOSTNAME.crt"
      SSLCertificateKeyFile "/etc/apache2/keys/HOSTNAME.key"
      #SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
      <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
      </FilesMatch>
      BrowserMatch ".*MSIE.*" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0
    </VirtualHost>
```
**Important:** Note that the line

```
    Alias /php-fpm /Library/WebServer/HOSTNAME.fcgi
```

is exactly the same in both configurations, but the FastCGIExternalServer directive **must** appear only in one of them.

### Explaining the directives

Let us dissect the essential parts of the virtual host configuration:

```
    AddHandler php-fastcgi .php
```
The AddHandler directive tells that files ending in .php should be handled by a handler called “php-fastcgi” (this name is arbitrary).

```
    Action php-fastcgi /php-fpm
```
The Action directive defines the handler called “php-fastcgi” to point to a (non-existent) script called “php-fpm” (again, the name is arbitrary).

```
    Alias /php-fpm /Library/WebServer/HOSTNAME.fcgi
```
The Alias directive defines the path /php-fpm to point to another path. This is the path that triggers the FastCGIExternalServer directive to forward the request to PHP-FPM. The way this path is chosen is very important, because PHP-FPM will not work unless the path satisfies some constraints. Let me try to explain. In principle, the path may be any “virtual” path (i.e., not existing in the file system), but it turns out (read this thread: http://www.fastcgi.com/archives/fastcgi-developers/2010-September/000594.html) that if the path contains slashes (apart from the leading slash), it won't work unless it is a real path (existing in the file system) accessible by Apache (e.g., /Library/WebServer). Confused? Well, I've spent days trying to figure out. If the alias is /some/path/to/HOSTNAME.fcgi then (1) /some/path/to/ must exist and (2) Apache must be “aware” of it. For example, since OS X Apache's DocumentRoot is set to /Library/WebServer/Documents, these aliases will all work: /HOSTNAME.fcgi (no slashes but the leading slash), /Library/HOSTNAME.fcgi, /Library/WebServer/HOSTNAME.fcgi, /Library/WebServer/Documents/HOSTNAME.fcgi (note, again, that HOSTNAME.fcgi itself does not have to exist in the file system). Note that such paths will work independent of the virtual host's DocumentRoot. If the virtual host's document root is set to /some/path/to/HOSTNAME then these will work, too (provided that /some/path/to exists): /some/HOSTNAME.fcgi, /some/path/HOSTNAME.fcgi, and /some/path/to/HOSTNAME.fcgi. However, /Library/WebServer/Documents/foo/HOSTNAME.fcgi will raise a `Not Found` error, unless the foo directory exists (it may be just an empty folder), and /some/path/to/foo/HOSTNAME.fcgi will raise an `Internal Server Error (Request exceeded the limit of 10 internal redirects due to probable configuration error)`.

The fact that the path must exist is probably a consequence of the way Apache resolves URI to file paths (it probably checks that the path exists), as FastCGI, _per se_, does not require that the path exist. Note also that the path must be unique across all the virtual hosts. Therefore, if you put your virtual hosts inside subfolders of /Library/WebServer, then /Library/WebServer/HOSTNAME.fcgi (or /Library/WebServer/whatever-unique-name) is always a good choice.

Finally, for all this to work, we must explicitly allow a redirection of /php-fpm, because the path we have chosen is not in the scope of Apache. This is the purpose of the Location directive.

These are a few links with additional details:

http://www.fastcgi.com/mod_fastcgi/docs/mod_fastcgi.html

http://www.fastcgi.com/docs/faq.html#FastCGIExternalServer

http://www.fastcgi.com/archives/fastcgi-developers/2010-September/000594.html



