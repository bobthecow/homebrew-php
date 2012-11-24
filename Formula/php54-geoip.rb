require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Geoip < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/geoip'
  url 'http://pecl.php.net/get/geoip-1.0.8.tgz'
  sha1 'f8d17da3e192002332ab54b9b4ab0f5deeaf9f15'
  head 'https://svn.php.net/repository/pecl/geoip/trunk/', :using => :svn
  version '1.0.8'

  depends_on 'geoip'

  def install
    Dir.chdir "geoip-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-geoip=#{Formula.factory('geoip').prefix}"
    system "make"
    prefix.install "modules/geoip.so"
    write_config_file unless build.include? "without-config-file"
  end
end
