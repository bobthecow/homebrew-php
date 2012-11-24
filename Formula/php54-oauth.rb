require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Oauth < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/oauth'
  url 'http://pecl.php.net/get/oauth-1.2.3.tgz'
  sha1 'e2a42961c8134746fc0cd8ef9bd433f760b94975'
  head 'https://svn.php.net/repository/pecl/oauth/trunk', :using => :svn

  def install
    Dir.chdir "oauth-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/oauth.so"
    write_config_file unless build.include? "without-config-file"
  end
end
