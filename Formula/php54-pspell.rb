require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Pspell < AbstractPhpExtension
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://www.php.net/get/php-5.4.6.tar.bz2/from/this/mirror'
  sha1 'a092ff9632f96189ade4415ca1e0a89cbc289a4b'
  version '5.4.6'

  depends_on 'aspell'
  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "ext/pspell"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--with-pspell=#{Formula.factory('aspell').prefix}"
    system "make"
    prefix.install "modules/pspell.so"
    write_config_file unless build.include? "without-config-file"
  end
end
