require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Mongo < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/mongo'
  url 'http://pecl.php.net/get/mongo-1.2.12.tgz'
  sha1 '5bf06a36f275e40378db1ebdfda6dfb93419ae60'
  head 'https://github.com/mongodb/mongo-php-driver.git'

  def install
    Dir.chdir "mongo-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/mongo.so"
    write_config_file unless build.include? "without-config-file"
  end
end
