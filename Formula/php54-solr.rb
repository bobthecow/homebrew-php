require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Solr < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/solr'
  url 'http://pecl.php.net/get/solr-1.0.2.tgz'
  md5 '1632144b462ab22b91d03e4d59704fab'
  head 'https://svn.php.net/repository/pecl/solr/trunk/', :using => :svn

  def install
    Dir.chdir "solr-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/solr.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
