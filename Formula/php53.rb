require File.join(File.dirname(__FILE__), 'abstract-php')

class Php53 < AbstractPhp
  url 'http://www.php.net/get/php-5.3.18.tar.bz2/from/this/mirror'
  sha1 '561b7ed1ad147346d97f4cac78159e5918a7b5b9'
  version '5.3.18'

  def php_version
    5.4
  end

  def php_version_path
    54
  end

end
