require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Intl < AbstractPhp53Extension
  init
  homepage 'http://php.net/manual/en/book.intl.php'
  url 'http://www.php.net/get/php-5.3.21.tar.bz2/from/this/mirror'
  sha1 'd67d2569b4782cf2faa049f22b08819ad8b15009'
  version '5.3.21'

  depends_on 'icu4c'

  def install
    Dir.chdir "ext/intl"

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--enable-intl"
    system "make"
    prefix.install "modules/intl.so"
    write_config_file unless build.include? "without-config-file"
  end
end
