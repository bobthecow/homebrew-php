require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Memcached < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  md5 'f81a5261be1c9848ed5c071a4ebe5e05'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  depends_on 'autoconf' => :build
  depends_on 'libmemcached'
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "memcached-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    system "make"
    prefix.install "modules/memcached.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
