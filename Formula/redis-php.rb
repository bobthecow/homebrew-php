require 'formula'

class RedisPhp < Formula
  homepage 'https://github.com/nicolasff/phpredis'
  url 'https://github.com/nicolasff/phpredis/tarball/2.1.3'
  md5 'eb2bee7e42f7a32a38c2a45377f21086'
  head 'https://github.com/nicolasff/phpredis.git'

  depends_on 'autoconf'

  def install
    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/redis.so'
  end

  def caveats; <<-EOS.undent
    To finish installing redis-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/redis.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the redis module.
      * If you see it, you have been successful!
    EOS
  end
end