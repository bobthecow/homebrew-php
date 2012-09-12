require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Memcached < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  sha1 '5442250bf4a9754534bce9a3033dc5363d8238f7'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  depends_on 'autoconf' => :build
  depends_on 'libmemcached'
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "memcached-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    system "make"
    prefix.install "modules/memcached.so"
    write_config_file unless build.include? "without-config-file"
  end
end
