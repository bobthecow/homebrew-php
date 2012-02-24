require 'formula'

class PspellPhp < Formula
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  depends_on 'aspell'

  def install
    cd "ext/pspell" do
      system "phpize"
      system "./configure", "--disable-debug",
                            "--prefix=#{prefix}",
                            "--with-pspell=#{Formula.factory('aspell').prefix}"
      system "make"
      prefix.install 'modules/pspell.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing the pspell module:
      * Add the following line to php.ini:
        extension="#{prefix}/pspell.so"
      * To verify, run "php -m" and look for the pspell module.
      * Restart your webserver
    EOS
  end
end
