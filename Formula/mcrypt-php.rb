require 'formula'

class McryptPhp < Formula
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  homepage 'http://php.net/manual/en/book.mcrypt.php'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  depends_on 'mcrypt'

  def install
    Dir.chdir "ext/mcrypt"
    system "phpize"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-mcrypt=#{Formula.factory('mcrypt').prefix}"
    system "make"
    prefix.install 'modules/mcrypt.so'
  end

  def caveats; <<-EOS.undent
    To finish mcrypt-php installation, you need to add the
    following line into php.ini:
      extension="#{prefix}/mcrypt.so"
    Then, restart your webserver and check in phpinfo if
    you're able to see something about mcrypt
    EOS
  end
end
