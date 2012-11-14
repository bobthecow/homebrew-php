require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Lzf < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/lzf'
  url 'http://pecl.php.net/get/LZF-1.6.2.tgz'
  sha1 '9e24976b65a000ea09f0860daa1de13d5de4f022'
  head 'https://svn.php.net/lzf/pecl/example/trunk', :using => :svn

  def install
    Dir.chdir "LZF-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/lzf.so"
    write_config_file unless build.include? "without-config-file"
  end
end
