require 'formula'

class Php53Ssh2 < Formula
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.11.3.tgz'
  md5 'd295c966adf1352cad187604b312c687'
  version '0.11.3'

  depends_on 'libssh2'

  def install
    Dir.chdir "ssh2-#{version}" do
      ENV.universal_binary unless Hardware.is_64_bit?

      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/ssh2.so"
    end
  end

  def caveats; <<-EOS.undent
    To finish installing php53-ssh2:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/ssh2.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * If you see it, you have been successful!
    EOS
  end
end
