require File.join(File.dirname(__FILE__), 'abstract-php')

class Php54 < AbstractPhp
  url 'http://www.php.net/get/php-5.4.8.tar.bz2/from/this/mirror'
  sha1 'ed9c4e31da827af8a4d4b1adf3dfde17d11c0b34'
  version '5.4.8'

  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn

  raise "Cannot build PHP 5.4 with Suhosin at this time" if build.include? 'with-suhosin'

  def install_args
    super + [
      "--enable-zend-signals",
      "--enable-dtrace",
    ]
  end

  def php_version
    5.4
  end

  def php_version_path
    54
  end

end
