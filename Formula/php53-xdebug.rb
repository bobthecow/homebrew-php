require 'formula'

class Php53Xdebug < Formula
  homepage 'http://xdebug.org'
  url 'http://xdebug.org/files/xdebug-2.2.0.tgz'
  md5 '27d8ad8224ffab04d12eecb5997a4f5d'

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "xdebug-#{version}"

    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make"
    prefix.install "modules/xdebug.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-xdebug:
      * Add the following line to #{etc}/php.ini:
        zend_extension="#{prefix}/xdebug.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xdebug module.
      * If you see it, you have been successful!
    EOS
  end
end
