require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Mcrypt < AbstractPhp53Extension
  init
  homepage 'http://php.net/manual/en/book.mcrypt.php'
  url 'http://www.php.net/get/php-5.3.18.tar.bz2/from/this/mirror'
  sha1 '561b7ed1ad147346d97f4cac78159e5918a7b5b9'
  version '5.3.18'

  depends_on 'mcrypt'

  def install
    Dir.chdir "ext/mcrypt"

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-mcrypt=#{Formula.factory('mcrypt').prefix}"
    system "make"
    prefix.install "modules/mcrypt.so"
    write_config_file unless build.include? "without-config-file"
  end
end
