require 'formula'

class Php54Midgard2 < Formula
  homepage 'http://www.midgard-project.org'
  head 'https://github.com/midgardproject/midgard-php5.git', :branch => 'ratatoskr'
  url 'https://github.com/midgardproject/midgard-php5/tarball/10.05.6'
  md5 'ba43c97c4c3c940d1b9b331986f33ee6'

  depends_on 'autoconf' => :build
  depends_on 'pkg-config' => :build
  depends_on 'midgard2'

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/midgard2.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-midgard2:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/midgard2.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the midgard2 module.
      * If you see it, you have been successful!
    EOS
  end
end
