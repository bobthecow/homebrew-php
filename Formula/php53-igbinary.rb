require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Igbinary < AbstractPhp53Extension
  init
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  sha1 'cebe34d18dd167a40a712a6826415e3e5395ab27'
  head 'https://github.com/igbinary/igbinary.git', :using => :git

  def install
    Dir.chdir "igbinary-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    include.install %w(apc_serializer.h hash.h hash_function.h igbinary.h php_igbinary.h)
    prefix.install %w(modules/igbinary.so)
    write_config_file unless build.include? "without-config-file"
  end
end
