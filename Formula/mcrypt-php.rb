require 'formula'

class McryptPhp < Formula
  homepage 'http://php.net/manual/en/book.mcrypt.php'
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  depends_on 'autoconf' => :build
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
    To finish installing mcrypt-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/mcrypt.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the mcrypt module.
      * If you see it, you have been successful!
    EOS
  end
end
