require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Memcache < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/memcache'
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  sha1 'be0b12fa09ed127dc35c0da29a576a9112be1bde'
  head 'https://svn.php.net/repository/pecl/memcache/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "memcache-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/memcache.so"
    write_config_file unless build.include? "without-config-file"
  end
end
