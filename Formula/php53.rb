require File.join(File.dirname(__FILE__), 'abstract-php')

class Php53 < AbstractPhp
  url 'http://www.php.net/get/php-5.3.17.tar.bz2/from/this/mirror'
  sha1 'd6f0192d2c1dae2921923762bde5ae356ceda5b5'
  version '5.3.17'

  def php_version
    5.4
  end

  def php_version_path
    54
  end

end
