require 'formula'

class Php53Intl < Formula
  homepage 'http://php.net/manual/en/book.intl.php'
  url 'http://www.php.net/get/php-5.3.13.tar.bz2/from/this/mirror'
  md5 '370be99c5cdc2e756c82c44d774933c8'
  version '5.3.13'

  depends_on 'autoconf' => :build
  depends_on 'icu4c'

  def install
    Dir.chdir "ext/intl"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-intl"
    system "make"
    prefix.install "modules/intl.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-intl:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/intl.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the intl module.
      * If you see it, you have been successful!
    EOS
  end
end
