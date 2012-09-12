require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Pcntl < AbstractPhpExtension
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.3.16.tar.bz2/from/this/mirror'
  sha1 'a8356b18f6413a87451bd70110b814c847b69f00'
  version '5.3.16'

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "ext/pcntl"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/pcntl.so"
    write_config_file unless build.include? "without-config-file"
  end
end
