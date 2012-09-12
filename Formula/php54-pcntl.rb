require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Pcntl < AbstractPhpExtension
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.4.6.tar.bz2/from/this/mirror'
  sha1 'a092ff9632f96189ade4415ca1e0a89cbc289a4b'
  version '5.4.6'

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

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
