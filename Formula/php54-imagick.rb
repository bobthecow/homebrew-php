require 'formula'

class Php54Imagick < Formula
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  md5 'de9cca809fb2db61f4cbd9fac4f69314'
  head 'https://svn.php.net/repository/pecl/imagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'imagemagick'

  def install
    Dir.chdir "imagick-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/imagick.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-imagick:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/imagick.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the imagick module.
      * If you see it, you have been successful!
    EOS
  end
end
