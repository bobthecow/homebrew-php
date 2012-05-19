require 'formula'

class MemcachePhp < Formula
  homepage 'http://pecl.php.net/package/memcache'
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  md5 '9542f1886b72ffbcb039a5c21796fe8a'
  head 'https://svn.php.net/repository/pecl/memcache/trunk/', :using => :svn

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "memcache-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/memcache.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing memcache-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/memcache.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the memcache module.
      * If you see it, you have been successful!
    EOS
  end
end
