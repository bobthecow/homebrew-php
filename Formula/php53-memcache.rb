require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Memcache < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/memcache'
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  md5 '9542f1886b72ffbcb039a5c21796fe8a'
  head 'https://svn.php.net/repository/pecl/memcache/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "memcache-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/memcache.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
