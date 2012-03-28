require 'formula'

class XcachePhp < Formula
  homepage 'http://xcache.lighttpd.net'
  url 'http://xcache.lighttpd.net/pub/Releases/1.3.2/xcache-1.3.2.tar.bz2'
  md5 '56ff8139c9773216dd6e2a85860aad94'

  depends_on 'autoconf'

  def install
    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary unless Hardware.is_64_bit?

    system "phpize"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/xcache.so'
  end

  def caveats; <<-EOS.undent
    To finish installing xcache-php:
      * Add the following line to #{etc}/php.ini:
        zend_extension="#{prefix}/xcache.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xcache module.
      * If you see it, you have been successful!
    EOS
  end
end
