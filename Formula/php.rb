require 'formula'

def mysql_installed?
  `which mysql_config`.length > 0
end

def postgres_installed?
  `which pg_config`.length > 0
end

class Php < Formula
  homepage 'http://php.net'
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn

  devel do
    url 'http://www.php.net/get/php-5.4.0.tar.bz2/from/this/mirror'
    md5 '04bb6f9d71ea86ba05685439d50db074'
    version '5.4.0'
  end

  # So PHP extensions don't report missing symbols
  skip_clean ['bin', 'sbin']

  depends_on 'freetds' if ARGV.include? '--with-mssql'
  depends_on 'gettext'
  depends_on 'gmp' if ARGV.include? '--with-gmp'
  depends_on 'icu4c' if ARGV.include? '--with-intl'
  depends_on 'imap-uw' if ARGV.include? '--with-imap'
  depends_on 'jpeg'
  depends_on 'libevent' if ARGV.include? '--with-fpm'
  depends_on 'libxml2'
  depends_on 'mcrypt'
  depends_on 'readline' unless ARGV.include? '--without-readline' or ARGV.build_devel? or ARGV.build_head?
  depends_on 'unixodbc' if ARGV.include? '--with-unixodbc'

  # Sanity Checks
  if ARGV.include? '--with-mysql' and ARGV.include? '--with-mariadb'
    raise "Cannot specify more than one MySQL variant to build against."
  elsif ARGV.include? '--with-mysql'
    depends_on 'mysql' => :recommended unless mysql_installed?
  elsif ARGV.include? '--with-mariadb'
    depends_on 'mariadb' => :recommended unless mysql_installed?
  end

  if ARGV.include? '--with-pgsql'
    depends_on 'postgresql' => :recommended unless postgres_installed?
  end

  if ARGV.include? '--with-cgi' and ARGV.include? '--with-fpm'
    raise "Cannot specify more than one executable to build."
  end

  if ARGV.include? '--with-cgi' or ARGV.include? '--with-fpm'
    ARGV << '--without-apache' unless ARGV.include? '--without-apache'
  end

  if ARGV.build_head? or ARGV.build_devel?
    raise "Cannot apply Suhosin Patch to unstable builds" if ARGV.include? '--with-suhosin'
  end

  def options
   [
     ['--with-mysql', 'Include MySQL support'],
     ['--with-mariadb', 'Include MariaDB support'],
     ['--with-pgsql', 'Include PostgreSQL support'],
     ['--with-mssql', 'Include MSSQL-DB support'],
     ['--with-unixodbc', 'Include unixODBC support'],
     ['--with-cgi', 'Enable building of the CGI executable (implies --without-apache)'],
     ['--with-fpm', 'Enable building of the fpm SAPI executable (implies --without-apache)'],
     ['--without-apache', 'Build without shared Apache 2.0 Handler module'],
     ['--with-intl', 'Include internationalization support'],
     ['--with-imap', 'Include IMAP extension'],
     ['--without-readline', 'Build without readline support'],
     ['--with-gmp', 'Include GMP support'],
     ['--with-suhosin', 'Include Suhosin patch'],
     ['--without-pear', 'Build without PEAR']
   ]
  end

  def patches
    p = [DATA]
    p << "http://download.suhosin.org/suhosin-patch-5.3.9-0.9.10.patch.gz" if ARGV.include? '--with-suhosin'
    return p
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--with-config-file-path=#{etc}",
      "--with-config-file-scan-dir=#{etc}/php5/conf.d",
      "--with-iconv-dir=/usr",
      "--enable-dba",
      "--with-ndbm=/usr",
      "--enable-exif",
      "--enable-soap",
      "--enable-sqlite-utf8",
      "--enable-wddx",
      "--enable-ftp",
      "--enable-sockets",
      "--enable-zip",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-sysvmsg",
      "--enable-mbstring",
      "--enable-mbregex",
      "--enable-zend-multibyte",
      "--enable-bcmath",
      "--enable-calendar",
      "--with-openssl=/usr",
      "--with-zlib=/usr",
      "--with-bz2=/usr",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-kerberos=/usr",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      "--with-xsl=/usr",
      "--with-curl=/usr",
      "--with-gd",
      "--enable-gd-native-ttf",
      "--with-freetype-dir=/usr/X11",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-png-dir=/usr/X11",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-snmp=/usr",
      "--with-tidy",
      "--with-mhash",
      "--mandir=#{man}"
    ]

    if ARGV.include? '--with-fpm'
      args << "--enable-fpm"
      (var+'log').mkpath
      touch var+'log/php-fpm.log'
      (prefix+'org.php-fpm.plist').write php_fpm_startup_plist
      (prefix+'org.php-fpm.plist').chmod 0644
    elsif ARGV.include? '--with-cgi'
      args << "--enable-cgi"
    end

    # Build Apache module by default
    unless ARGV.include? '--without-apache'
      args << "--with-apxs2=/usr/sbin/apxs"
      args << "--libexecdir=#{libexec}"
    end

    unless ARGV.include? '--without-readline' or ARGV.build_devel? or ARGV.build_head?
      args << "--with-readline=#{Formula.factory('readline').prefix}" 
    end

    if ARGV.include? '--with-gmp'
      args << "--with-gmp" 
    end

    if ARGV.include? '--with-imap'
      args << "--with-imap=#{Formula.factory('imap-uw').prefix}"
      args << "--with-imap-ssl=/usr"
    end

    if ARGV.include? '--with-intl'
      args << "--enable-intl"
      args << "--with-icu-dir=#{Formula.factory('icu4c').prefix}"
    end

    if ARGV.include? '--with-mssql'
      args << "--with-mssql=#{Formula.factory('freetds').prefix}"
      args << "--with-pdo-dblib=#{Formula.factory('freetds').prefix}"
    end

    if ARGV.include? '--with-mysql' or ARGV.include? '--with-mariadb'
      args << "--with-mysql-sock=/tmp/mysql.sock"
      args << "--with-mysqli=mysqlnd"
      args << "--with-mysql=mysqlnd"
      args << "--with-pdo-mysql=mysqlnd"
    end

    if ARGV.include? '--with-pgsql'
      args << "--with-pgsql=#{Formula.factory('postgresql').prefix}"
      args << "--with-pdo-pgsql=#{Formula.factory('postgresql').prefix}"
    end

    if ARGV.include? '--with-unixodbc'
      args << "--with-unixODBC=#{Formula.factory('unixodbc').prefix}"
      args << "--with-pdo-odbc=unixODBC,#{Formula.factory('unixodbc').prefix}"
    else
      args << "--with-iodbc"
    end

    # Use libedit instead of readline for 5.4
    args << "--with-libedit" if ARGV.build_devel? or ARGV.build_head?

    system "./buildconf" if ARGV.build_head?
    system "./configure", *args

    unless ARGV.include? '--without-apache'
      # Use Homebrew prefix for the Apache libexec folder
      inreplace "Makefile",
        "INSTALL_IT = $(mkinstalldirs) '$(INSTALL_ROOT)/usr/libexec/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='$(INSTALL_ROOT)/usr/libexec/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so",
        "INSTALL_IT = $(mkinstalldirs) '#{libexec}/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='#{libexec}/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so"
    end

    if ARGV.include? '--with-intl'
      inreplace 'Makefile' do |s|
        s.change_make_var! "EXTRA_LIBS", "\\1 -lstdc++"
      end
    end

    if ARGV.include? '--without-pear'
      args << "--without-pear"
    end

    system "make"
    ENV.deparallelize # parallel install fails on some systems
    system "make install"

    etc.install "./php.ini-production" => "php.ini" unless File.exists? etc+"php.ini"
    chmod_R 0775, lib+"php"
    system bin+"pear", "config-set", "php_ini", etc+"php.ini" unless ARGV.include? '--without-pear'
    if ARGV.include?('--with-fpm') and not File.exists? etc+"php-fpm.conf"
      etc.install "sapi/fpm/php-fpm.conf"
      inreplace etc+"php-fpm.conf" do |s|
        s.sub!(/^;?daemonize\s*=.+$/,'daemonize = no')
        s.sub!(/^;?pm\.start_servers\s*=.+$/,'pm.start_servers = 20')
        s.sub!(/^;?pm\.min_spare_servers\s*=.+$/,'pm.min_spare_servers = 5')
        s.sub!(/^;?pm\.max_spare_servers\s*=.+$/,'pm.max_spare_servers = 35')
      end
    end
  end

 def caveats; <<-EOS
For 10.5 and Apache:
    Apache needs to run in 32-bit mode. You can either force Apache to start
    in 32-bit mode or you can thin the Apache executable.

To enable PHP in Apache add the following to httpd.conf and restart Apache:
    LoadModule php5_module    #{libexec}/apache2/libphp5.so

The php.ini file can be found in:
    #{etc}/php.ini

Development and head builds will use libedit in place of readline.

If you have installed the formula with --with-fpm, to launch php-fpm on startup:
    * If this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.php-fpm.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.php-fpm.plist

    * If this is an upgrade and you already have the org.php-fpm.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.php-fpm.plist
        cp #{prefix}/org.php-fpm.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.php-fpm.plist

You may also need to edit the plist to use the correct "UserName".
   EOS
 end

  def test
    if ARGV.include?('--with-fpm')
      system "#{sbin}/php-fpm -y #{etc}/php-fpm.conf -t"
    end
  end

  def php_fpm_startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>org.php-fpm</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/php-fpm</string>
        <string>--fpm-config</string>
        <string>#{etc}/php-fpm.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardErrorPath</key>
      <string>#{prefix}/var/log/php-fpm.log</string>
    </dict>
    </plist>
    EOPLIST
  end
end

__END__
diff -Naur php-5.3.2/ext/tidy/tidy.c php/ext/tidy/tidy.c 
--- php-5.3.2/ext/tidy/tidy.c	2010-02-12 04:36:40.000000000 +1100
+++ php/ext/tidy/tidy.c	2010-05-23 19:49:47.000000000 +1000
@@ -22,6 +22,8 @@
 #include "config.h"
 #endif
 
+#include "tidy.h"
+
 #include "php.h"
 #include "php_tidy.h"
 
@@ -31,7 +33,6 @@
 #include "ext/standard/info.h"
 #include "safe_mode.h"
 
-#include "tidy.h"
 #include "buffio.h"
 
 /* compatibility with older versions of libtidy */
