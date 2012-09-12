require 'formula'

def php54_installed?
  `php -v`.match(/5\.4\./)
end

def php53_installed?
  `php -v`.match(/5\.3\./)
end


class Phpmyadmin < Formula
  homepage 'http://www.phpmyadmin.net'
  url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.2.1/phpMyAdmin-3.5.2.1-all-languages.tar.bz2'
  sha1 '26dce3c67e6d57b132530d2efeebabbf87064c73'

  depends_on 'josegonzalez/php/php53-mcrypt' if php53_installed?
  depends_on 'josegonzalez/php/php54-mcrypt' if php54_installed?

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
