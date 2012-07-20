require 'formula'

class Php54Xdebug < Formula
  homepage 'http://xdebug.org'
  url 'http://xdebug.org/files/xdebug-2.2.1.tgz'
  md5 '5e5c467e920240c20f165687d7ac3709'

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
    To finish installing php54-xdebug:
      * Add the following line to #{etc}/php.ini:
        zend_extension="#{prefix}/xdebug.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xdebug module.
      * If you see it, you have been successful!
    EOS
  end
end
