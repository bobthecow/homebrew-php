require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Intl < AbstractPhp54Extension
  init
  homepage 'http://php.net/manual/en/book.intl.php'
  url 'http://www.php.net/get/php-5.4.11.tar.bz2/from/this/mirror'
  sha1 '85666f32bf1f2850c769fe58fed788ae8fdfa1cb'
  version '5.4.11'

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
