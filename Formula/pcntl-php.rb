require 'formula'

class PcntlPhp < Formula
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  def install
    Dir.chdir "ext/pcntl"
    system "phpize"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/pcntl.so"
  end

  def caveats; <<-EOS.undent
    To finish installing pcntl-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/pcntl.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the pcntl module.
      * If you see it, you have been successful!
    EOS
  end
end
