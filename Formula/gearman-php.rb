require 'formula'

class GearmanPhp < Formula
  homepage 'http://pecl.php.net/package/gearman'
  url 'http://pecl.php.net/get/gearman-1.0.2.tgz'
  md5 '98464746d1de660f15a25b1bc8fcbc8a'

  depends_on 'autoconf' => :build
  depends_on 'gearman'

  def install
    cd "gearman-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}",
                            "--with-gearman=#{Formula.factory('gearman').prefix}"
      system "make"
      prefix.install 'modules/gearman.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing gearman-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/gearman.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the gearman module.
      * If you see it, you have been successful!
    EOS
  end
end
