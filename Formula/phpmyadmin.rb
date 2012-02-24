require 'formula'

class Phpmyadmin < Formula
  url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.4.10.1/phpMyAdmin-3.4.10.1-all-languages.tar.bz2'
  homepage 'http://www.phpmyadmin.net/documentation'
  md5 '9eed98427c27685d665630b1aded1d85'
  version '3.4.10.1'

  depends_on 'mcrypt-php'

  def install
    (share+'phpmyadmin').install Dir['*']
  end

  def caveats; <<-EOS.undent
    Note that this formula will NOT install mysql. It is not
    required since you might want to get connected to a remote
    database server.

    Webserver configuration example (add this at the end of
    your /etc/apache2/httpd.conf for instance) :
      Alias /phpmyadmin #{HOMEBREW_PREFIX}/share/phpmyadmin
      <Directory #{HOMEBREW_PREFIX}/share/phpmyadmin/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>
    Then, open http://localhost/phpmyadmin

    More documentation : file://#{share}/phpmyadmin/Documentation.html
    EOS
  end
end
