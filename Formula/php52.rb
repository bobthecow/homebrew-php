require File.join(File.dirname(__FILE__), 'abstract-php')

class Php52 < AbstractPhp
  url 'http://www.php.net/get/php-5.2.17.tar.bz2/from/this/mirror'
  sha1 'd68f3b09f766990d815a3c4c63c157db8dab8095'
  version '5.2.17'

  def php_version
    5.2
  end

  def php_version_path
    52
  end

end
