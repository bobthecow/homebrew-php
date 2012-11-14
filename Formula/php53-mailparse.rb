require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Mailparse < AbstractPhp53Extension
  init
  homepage 'http://pecl.php.net/package/mailparse'
  url 'http://pecl.php.net/get/mailparse-2.1.6.tgz'
  sha1 'f0deaa433a1f7833e80f80dabc1bbbdbe0071b3c'
  head 'https://svn.php.net/repository/pecl/mailparse/trunk', :using => :svn

  depends_on 'pcre'

  def install
    Dir.chdir "mailparse-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/mailparse.so"
    write_config_file unless build.include? "without-config-file"
  end
end
