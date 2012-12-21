require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Pspell < AbstractPhp53Extension
  init
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://www.php.net/get/php-5.3.20.tar.bz2/from/this/mirror'
  md5 '00241b9e89e93adf3baac32c56211e4e'
  version '5.3.20'

  depends_on 'aspell'

  def install
    Dir.chdir "ext/pspell"

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-debug",
                          "--with-pspell=#{Formula.factory('aspell').prefix}"
    system "make"
    prefix.install "modules/pspell.so"
    write_config_file unless build.include? "without-config-file"
  end
end
