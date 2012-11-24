require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Imagick < AbstractPhp53Extension
  init
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  sha1 '29b6dcd534cde6b37ebe3ee5077b71a9eed685c2'
  head 'https://svn.php.net/repository/pecl/imagick/trunk/', :using => :svn

  depends_on 'imagemagick'

  def install
    Dir.chdir "imagick-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/imagick.so"
    write_config_file unless build.include? "without-config-file"
  end
end
