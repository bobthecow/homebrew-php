require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Yaf < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/yaf'
  url 'http://pecl.php.net/get/yaf-2.2.2.tgz'
  sha1 '826f85b7b641a7418110f73f823749509c58b1b7'
  head 'https://svn.php.net/repository/pecl/yaf/trunk/', :using => :svn

  depends_on 'pcre'

  def install
    Dir.chdir "yaf-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/yaf.so"
    write_config_file unless build.include? "without-config-file"
  end
end
