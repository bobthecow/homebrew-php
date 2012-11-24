require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Libevent < AbstractPhp53Extension
  init
  homepage 'http://pecl.php.net/package/libevent'
  url 'http://pecl.php.net/get/libevent-0.0.5.tgz'
  sha1 '0817616ef02a5ab2bbc804dad121239391578956'
  version '0.0.5'

  depends_on 'libevent'

  def install
    Dir.chdir "libevent-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-libevent=#{Formula.factory('libevent').prefix}"
    system "make"
    prefix.install "modules/libevent.so"
    write_config_file unless build.include? "without-config-file"
  end
end
