require 'formula'

class XdebugPhp < Formula
  homepage 'http://xdebug.org'
  url 'http://www.xdebug.org/files/xdebug-2.1.3.tgz'
  md5 '779f4a66acdccd673553769e403674c4'

  depends_on 'autoconf'

  def install
    Dir.chdir "xdebug-#{version}" do
      # See https://github.com/mxcl/homebrew/issues/issue/69
      ENV.universal_binary

      system "phpize"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--enable-xdebug"
      system "make"
      prefix.install 'modules/xdebug.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing xdebug-php:
      * Add the following line to #{etc}/php.ini:
        zend_extension="#{prefix}/xdebug.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xdebug module.
      * If you see it, you have been successful!
    EOS
  end
end
