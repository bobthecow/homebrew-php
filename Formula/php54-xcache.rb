require 'formula'

class Php54Xcache < Formula
  homepage 'http://xcache.lighttpd.net'
  url 'http://xcache.lighttpd.net/pub/Releases/2.0.0/xcache-2.0.0.tar.bz2'
  md5 '0e30cdff075c635e475d70a5c37d0252'

  depends_on 'autoconf' => :build

  def install
    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary unless Hardware.is_64_bit?

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/xcache.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-xcache:
      * Add the following line to #{etc}/php.ini:
        zend_extension="#{prefix}/xcache.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xcache module.
      * If you see it, you have been successful!
    EOS
  end
end
