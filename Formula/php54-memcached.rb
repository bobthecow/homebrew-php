require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Memcached < AbstractPhp54Extension
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  sha1 '5442250bf4a9754534bce9a3033dc5363d8238f7'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  def self.init
    super
    option 'with-igbinary', "Build with igbinary support"
    depends_on 'libmemcached'
    depends_on 'php54-igbinary' if build.include?('with-igbinary')
  end

  init

  def install
    Dir.chdir "memcached-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    args = []
    args << "--prefix=#{prefix}"
    args << phpconfig
    args << "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    args << "--enable-memcached-igbinary" if build.include? 'with-igbinary'

    safe_phpize

    if build.include? 'with-igbinary'
      system "mkdir -p ext/igbinary"
      cp "#{Formula.factory('php54-igbinary').prefix}/include/igbinary.h", "ext/igbinary/igbinary.h"
    end

    system "./configure", *args
    system "make"
    prefix.install "modules/memcached.so"
    write_config_file unless build.include? "without-config-file"
  end
end
