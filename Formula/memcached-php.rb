require 'formula'

class MemcachedPhp < Formula
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  homepage 'http://pecl.php.net/package/memcached'
  md5 'f81a5261be1c9848ed5c071a4ebe5e05'

  depends_on 'libmemcached'

  def install
    Dir.chdir "memcached-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}",
                            "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
      system "make"
      prefix.install 'modules/memcached.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing memcached:
      * Add the following line to php.ini:
        extension="#{prefix}/memcached.so"
      * Restart your webserver
    EOS
  end
end
