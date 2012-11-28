require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Memcached < AbstractPhp53Extension
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.1.0.tgz'
  sha1 '16fac6bfae8ec7e2367fda588b74df88c6f11a8e'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  def self.init
    super
    option 'with-igbinary', "Build with igbinary support"
    depends_on 'libmemcached'
    depends_on 'php53-igbinary' if build.include?('with-igbinary')
  end

  init

  def install
    Dir.chdir "memcached-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    args = []
    args << "--prefix=#{prefix}"
    args << phpconfig
    args << "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    args << "--enable-memcached-igbinary" if build.include? 'with-igbinary'

    safe_phpize

    if build.include? 'with-igbinary'
      system "mkdir -p ext/igbinary"
      cp "#{Formula.factory('php53-igbinary').prefix}/include/igbinary.h", "ext/igbinary/igbinary.h"
    end

    system "./configure", *args
    system "make"
    prefix.install "modules/memcached.so"
    write_config_file unless build.include? "without-config-file"
  end
end
