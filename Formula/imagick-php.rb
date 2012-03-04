require 'formula'

class ImagickPhp < Formula
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.0.1.tgz'
  md5 'e2167713316639705202cf9b6cb1fdb1'

  depends_on 'imagemagick'

  def install
    Dir.chdir "imagick-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/imagick.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing imagick-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/imagick.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the imagick module.
      * If you see it, you have been successful!
    EOS
  end
end
