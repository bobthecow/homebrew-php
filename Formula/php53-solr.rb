require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Solr < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/solr'
  url 'http://pecl.php.net/get/solr-1.0.2.tgz'
  sha1 '2412c77bd86e70bfcd25473a7ed70e4631ffafcc'
  head 'https://svn.php.net/repository/pecl/solr/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "solr-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/solr.so"
    write_config_file unless build.include? "without-config-file"
  end
end
