require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Mongo < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/mongo'
  url 'http://pecl.php.net/get/mongo-1.2.12.tgz'
  sha1 '5bf06a36f275e40378db1ebdfda6dfb93419ae60'
  head 'https://github.com/mongodb/mongo-php-driver.git'

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "mongo-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/mongo.so"
    write_config_file unless build.include? "without-config-file"
  end
end
