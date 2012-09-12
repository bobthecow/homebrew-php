require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Http < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/pecl_http'
  url 'http://pecl.php.net/get/pecl_http-1.7.4.tgz'
  sha1 '3a2276c765fccb58ae0a96e71bde26657952d139'
  head 'http://svn.php.net/repository/pecl/http/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "pecl_http-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/http.so"
    write_config_file unless build.include? "without-config-file"
  end
end
