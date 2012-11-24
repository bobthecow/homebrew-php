require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Solr < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/solr'
  url 'http://pecl.php.net/get/solr-1.0.2.tgz'
  sha1 '2412c77bd86e70bfcd25473a7ed70e4631ffafcc'
  head 'https://svn.php.net/repository/pecl/solr/trunk/', :using => :svn

  def install
    Dir.chdir "solr-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/solr.so"
    write_config_file unless build.include? "without-config-file"
  end
end
