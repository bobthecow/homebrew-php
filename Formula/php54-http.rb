require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Http < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/pecl_http'
  url 'http://pecl.php.net/get/pecl_http-1.7.4.tgz'
  md5 '288bae57b89d8de4bdd7d7dc5954cf8c'
  version '1.7.4'
  head 'http://svn.php.net/repository/pecl/http/trunk/', :using => :svn

  def install
    Dir.chdir "pecl_http-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/http.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
