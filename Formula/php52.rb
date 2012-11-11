require File.join(File.dirname(__FILE__), 'abstract-php')

class Php52 < AbstractPhp
  init
  url 'http://www.php.net/get/php-5.2.17.tar.bz2/from/this/mirror'
  sha1 'd68f3b09f766990d815a3c4c63c157db8dab8095'
  version '5.2.17'

  depends_on 'mhash'
  depends_on 'libevent' if build.include? 'with-fpm'

  def php_version
    5.2
  end

  def php_version_path
    52
  end

  def install_args
    defaults = super
    defaults.delete '--with-mhash'
    defaults + [
      "--enable-zend-multibyte",
      "--enable-sqlite-utf8",
      "--with-mhash=#{Formula.factory('mhash').prefix}"
    ]
  end

  def default_config
    "./php.ini-recommended"
  end

  def skip_pear_config_set?
    true
  end

end
