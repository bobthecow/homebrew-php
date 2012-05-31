require 'formula'

class Php54Pspell < Formula
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://www.php.net/get/php-5.4.3.tar.bz2/from/this/mirror'
  md5 '51f9488bf8682399b802c48656315cac'
  version '5.4.3'

  depends_on 'autoconf' => :build
  depends_on 'aspell'

  def install
    Dir.chdir "ext/pspell"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--with-pspell=#{Formula.factory('aspell').prefix}"
    system "make"
    prefix.install "modules/pspell.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-pspell:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/pspell.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the pspell module.
      * If you see it, you have been successful!
    EOS
  end
end
