require 'formula'

def postgres_installed?
  `which pg_config`.length > 0
end

class Php54 < Formula
  homepage 'http://php.net'
  url 'http://www.php.net/get/php-5.4.6.tar.bz2/from/this/mirror'
  sha1 'a092ff9632f96189ade4415ca1e0a89cbc289a4b'
  version '5.4.6'

  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn

  # So PHP extensions don't report missing symbols
  skip_clean ['bin', 'sbin']

  depends_on 'curl'
  depends_on 'freetds' if build.include? 'with-mssql'
  depends_on 'freetype'
  depends_on 'gettext'
  depends_on 'gmp' if build.include? 'with-gmp'
  depends_on 'icu4c' if build.include? 'with-intl'
  depends_on 'imap-uw' if build.include? 'with-imap'
  depends_on 'jpeg'

  depends_on 'libpng'
  depends_on 'libxml2' unless MacOS.version >= :mountain_lion
  depends_on 'mcrypt'
  depends_on 'openssl' if build.include? 'with-homebrew-openssl'
  depends_on 'tidy' if build.include? 'with-tidy'
  depends_on 'unixodbc' if build.include? 'with-unixodbc'
  depends_on 'homebrew/dupes/zlib'

  # Sanity Checks
  mysql_opts = [ 'with-libmysql', 'with-mariadb', 'with-mysql' ]
  if mysql_opts.select {|o| build.include? o}.length > 1
    raise "Cannot specify more than one MySQL variant to build against."
  end

  if build.include? 'with-pgsql'
    depends_on 'postgresql' => :recommended unless postgres_installed?
  end

  if build.include? 'with-cgi' and build.include? 'with-fpm'
    raise "Cannot specify more than one executable to build."
  end

  if build.head?
    raise "Cannot apply Suhosin Patch to unstable builds" if build.include? 'with-suhosin'
  end

  if build.include? 'with-suhosin'
    raise "Cannot build PHP 5.4.5 with Suhosin at this time"
  end

  option '32-bit', "Build 32-bit only."
  option 'with-libmysql', 'Include (old-style) libmysql support'
  option 'with-mariadb', 'Include MariaDB support'
  option 'with-mysql', 'Include MySQL support'
  option 'with-pgsql', 'Include PostgreSQL support'
  option 'with-mssql', 'Include MSSQL-DB support'
  option 'with-unixodbc', 'Include unixODBC support'
  option 'with-cgi', 'Enable building of the CGI executable (implies --without-apache)'
  option 'with-fpm', 'Enable building of the fpm SAPI executable (implies --without-apache)'
  option 'without-apache', 'Build without shared Apache 2.0 Handler module'
  option 'with-intl', 'Include internationalization support'
  option 'with-imap', 'Include IMAP extension'
  option 'with-gmp', 'Include GMP support'
  option 'with-suhosin', 'Include Suhosin patch'
  option 'with-tidy', 'Include Tidy support'
  option 'without-pear', 'Build without PEAR'
  option 'with-homebrew-openssl', 'Include OpenSSL support via Homebrew'
  option 'without-bz2', 'Build without bz2 support'

  def config_path
    etc+"php/5.4"
  end

  def home_path
    File.expand_path("~")
  end

  def install
    # Not removing all pear.conf's from PHP path results in the PHP
    # configure not properly setting the pear binary to be installed
    config_pear = "#{config_path}/pear.conf"
    user_pear = "#{home_path}/pear.conf"
    if File.exists?(config_pear) || File.exists?(user_pear)
      opoo "Backing up all known pear.conf files"
      opoo <<-INFO
If you have a pre-existing pear install outside
         of homebrew-php, and you are using a non-standard
         pear.conf location, installation may fail.
INFO
      mv(config_pear, "#{config_pear}-backup") if File.exists? config_pear
      mv(user_pear, "#{user_pear}-backup") if File.exists? user_pear
    end

    begin
      _install
      rm_f("#{config_pear}-backup") if File.exists? "#{config_pear}-backup"
      rm_f("#{user_pear}-backup") if File.exists? "#{user_pear}-backup"
    rescue Exception => e
      mv("#{config_pear}-backup", config_pear) if File.exists? "#{config_pear}-backup"
      mv("#{user_pear}-backup", user_pear) if File.exists? "#{user_pear}-backup"
      throw e
    end
  end

  def _install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--localstatedir=#{var}",
      "--sysconfdir=#{config_path}",
      "--with-config-file-path=#{config_path}",
      "--with-config-file-scan-dir=#{config_path}/conf.d",
      "--with-iconv-dir=/usr",
      "--enable-dba",
      "--with-ndbm=/usr",
      "--enable-exif",
      "--enable-soap",

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
      "--enable-zend-signals",
      "--enable-dtrace",
      "--enable-bcmath",
      "--enable-calendar",
      "--with-zlib=#{Formula.factory('zlib').prefix}",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-kerberos=/usr",
      "--with-xsl=/usr",
      "--with-curl=#{Formula.factory('curl').prefix}",
      "--with-gd",
      "--enable-gd-native-ttf",
      "--with-freetype-dir=#{Formula.factory('freetype').prefix}",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-png-dir=#{Formula.factory('libpng').prefix}",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-snmp=/usr",
      "--with-mhash",
      "--mandir=#{man}",
    ]

    unless MacOS.version >= :mountain_lion
      args << "--with-libxml-dir=#{Formula.factory('libxml2').prefix}"
    end

    unless build.include? 'without-bz2'
      args << '--with-bz2=/usr'
    end

    if build.include? 'with-homebrew-openssl'
      args << "--with-openssl=" + Formula.factory('openssl').prefix.to_s
    else
      args << "--with-openssl=/usr"
    end

    if build.include? 'with-fpm'
      args << "--enable-fpm"
      args << "--with-fpm-user=_www"
      args << "--with-fpm-group=_www"
      (prefix+'var/log').mkpath
      touch prefix+'var/log/php-fpm.log'
      (prefix+'homebrew-php.josegonzalez.php54.plist').write php_fpm_startup_plist
      (prefix+'homebrew-php.josegonzalez.php54.plist').chmod 0644
    elsif build.include? 'with-cgi'
      args << "--enable-cgi"
    end

    # Build Apache module by default
    unless build.include? 'without-apache' or build.include? 'with-cgi' or build.include? 'with-fpm'
      args << "--with-apxs2=/usr/sbin/apxs"
      args << "--libexecdir=#{libexec}"
    end

    if build.include? 'with-gmp'
      args << "--with-gmp=#{Formula.factory('gmp').prefix}"
    end

    if build.include? 'with-imap'
      args << "--with-imap=#{Formula.factory('imap-uw').prefix}"
      args << "--with-imap-ssl=/usr"
    end

    if build.include? 'with-intl'
      args << "--enable-intl"
      args << "--with-icu-dir=#{Formula.factory('icu4c').prefix}"
    end

    if build.include? 'with-mssql'
      args << "--with-mssql=#{Formula.factory('freetds').prefix}"
      args << "--with-pdo-dblib=#{Formula.factory('freetds').prefix}"
    end

    if build.include? 'with-libmysql'
      args << "--with-mysql-sock=/tmp/mysql.sock"
      args << "--with-mysqli=/usr/local/bin/mysql_config"
      args << "--with-mysql=/usr/local"
      args << "--with-pdo-mysql=/usr/local"
    end

    if build.include? 'with-mysql' or build.include? 'with-mariadb'
      args << "--with-mysql-sock=/tmp/mysql.sock"
      args << "--with-mysqli=mysqlnd"
      args << "--with-mysql=mysqlnd"
      args << "--with-pdo-mysql=mysqlnd"
    end

    if build.include? 'with-pgsql' and File.directory? Formula.factory('postgresql').prefix.to_s
      args << "--with-pgsql=#{Formula.factory('postgresql').prefix}"
      args << "--with-pdo-pgsql=#{Formula.factory('postgresql').prefix}"
    elsif build.include? 'with-pgsql'
      args << "--with-pgsql=#{`pg_config --includedir`}"
      args << "--with-pdo-pgsql=#{`which pg_config`}"
    end

    if build.include? 'with-tidy'
      args << "--with-tidy=#{Formula.factory('tidy').prefix}"
    end

    if build.include? 'with-unixodbc'
      args << "--with-unixODBC=#{Formula.factory('unixodbc').prefix}"
      args << "--with-pdo-odbc=unixODBC,#{Formula.factory('unixodbc').prefix}"
    else
      args << "--with-iodbc"
      args << "--with-pdo-odbc=generic,/usr,iodbc"
    end

    if build.include? 'without-pear'
      args << "--without-pear"
    end

    # Use libedit instead of readline for 5.4
    args << "--with-libedit"

    system "./buildconf" if build.head?
    system "./configure", *args

    unless build.include? 'without-apache'
      # Use Homebrew prefix for the Apache libexec folder
      inreplace "Makefile",
        "INSTALL_IT = $(mkinstalldirs) '$(INSTALL_ROOT)/usr/libexec/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='$(INSTALL_ROOT)/usr/libexec/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so",
        "INSTALL_IT = $(mkinstalldirs) '#{libexec}/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='#{libexec}/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so"
    end

    if build.include? 'with-intl'
      inreplace 'Makefile' do |s|
        s.change_make_var! "EXTRA_LIBS", "\\1 -lstdc++"
      end
    end

    system "make"
    ENV.deparallelize # parallel install fails on some systems
    system "make install"

    config_path.install "./php.ini-development" => "php.ini" unless File.exists? config_path+"php.ini"
    chmod_R 0775, lib+"php"
    system bin+"pear", "config-set", "php_ini", config_path+"php.ini" unless build.include? 'without-pear'
    if build.include?('--with-fpm') and not File.exists? config_path+"php-fpm.conf"
      config_path.install "sapi/fpm/php-fpm.conf"
      inreplace config_path+"php-fpm.conf" do |s|
        s.sub!(/^;?daemonize\s*=.+$/,'daemonize = no')
        s.sub!(/^;include\s*=.+$/,";include=#{config_path}/fpm.d/*.conf")
        s.sub!(/^;?pm\.max_children\s*=.+$/,'pm.max_children = 10')
        s.sub!(/^;?pm\.start_servers\s*=.+$/,'pm.start_servers = 3')
        s.sub!(/^;?pm\.min_spare_servers\s*=.+$/,'pm.min_spare_servers = 2')
        s.sub!(/^;?pm\.max_spare_servers\s*=.+$/,'pm.max_spare_servers = 5')
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
    #{config_path}/php.ini

If pear complains about permissions, 'Fix' the default PEAR permissions and config:
    chmod -R ug+w #{lib}/php
    pear config-set php_ini #{etc}/php/5.4/php.ini

If you are having issues with custom extension compiling, ensure that this php is
in your PATH:
    PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"

If you have installed the formula with --with-fpm, to launch php-fpm on startup:
    * If this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/homebrew-php.josegonzalez.php54.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist

    * If this is an upgrade and you already have the homebrew-php.josegonzalez.php54.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist
        cp #{prefix}/homebrew-php.josegonzalez.php54.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist

You may also need to edit the plist to use the correct "UserName".

Please note that the plist was called 'org.php-fpm.plist' in old versions
of this formula.
   EOS
 end

  def test
    if build.include?('--with-fpm')
      system "#{sbin}/php-fpm -y #{config_path}/php-fpm.conf -t"
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
      <string>homebrew-php.josegonzalez.php54</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/php-fpm</string>
        <string>--fpm-config</string>
        <string>#{config_path}/php-fpm.conf</string>
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
