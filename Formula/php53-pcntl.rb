require 'formula'

class Php53Pcntl < Formula
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.3.13.tar.bz2/from/this/mirror'
  md5 '370be99c5cdc2e756c82c44d774933c8'
  version '5.3.13'

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "ext/pcntl"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/pcntl.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-pcntl:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/pcntl.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the pcntl module.
      * If you see it, you have been successful!
    EOS
  end
end
