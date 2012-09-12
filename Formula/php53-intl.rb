require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Intl < AbstractPhpExtension
  homepage 'http://php.net/manual/en/book.intl.php'
  url 'http://www.php.net/get/php-5.3.16.tar.bz2/from/this/mirror'
  sha1 'a8356b18f6413a87451bd70110b814c847b69f00'
  version '5.3.16'

  depends_on 'autoconf' => :build
  depends_on 'icu4c'
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "ext/intl"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-intl"
    system "make"
    prefix.install "modules/intl.so"
    write_config_file unless build.include? "without-config-file"
  end
end
