require 'formula'

class PcntlPhp < Formula
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.3.13.tar.bz2/from/this/mirror'
  md5 '370be99c5cdc2e756c82c44d774933c8'
  version '5.3.13'

  depends_on 'autoconf' => :build

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
