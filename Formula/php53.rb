require File.join(File.dirname(__FILE__), 'abstract-php')

class Php53 < AbstractPhp
  url 'http://www.php.net/get/php-5.3.18.tar.bz2/from/this/mirror'
  sha1 '561b7ed1ad147346d97f4cac78159e5918a7b5b9'
  version '5.3.18'

  depends_on 'libevent' if build.include? 'with-fpm'

  def install_args
    super + [
      "--enable-zend-multibyte",
      "--enable-sqlite-utf8",
    ]
  end

  def patches
    "http://download.suhosin.org/suhosin-patch-5.3.9-0.9.10.patch.gz" if build.include? 'with-suhosin'
  end

  def php_version
    5.3
  end

  def php_version_path
    53
  end

end
