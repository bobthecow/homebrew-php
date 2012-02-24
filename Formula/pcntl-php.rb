require 'formula'

class PcntlPhp < Formula
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  homepage 'http://php.net/manual/en/book.pcntl.php'
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
    To finish pcntl-php installation, you need to add the
    following line into php.ini:
      extension="#{prefix}/pcntl.so"
    Then, restart your webserver and check in phpinfo if
    you're able to see something about pcntl.
    EOS
  end
end
