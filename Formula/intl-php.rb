require 'formula'

class IntlPhp < Formula
  homepage 'http://php.net/manual/en/book.intl.php'
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  depends_on 'autoconf' => :build
  depends_on 'icu4c'

  def install
    Dir.chdir "ext/intl"
    system "phpize"
    system "./configure", "--enable-intl",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/intl.so'
  end

  def caveats; <<-EOS.undent
    To finish intl-php installation, you need to add the
    following line into #{etc}/php.ini:

      extension=#{prefix}/intl.so

    Then, restart your webserver and check in phpinfo if
    you're able to see something about intl
    EOS
  end
end
