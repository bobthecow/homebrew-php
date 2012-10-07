require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Oauth < AbstractPhp54Extension
  homepage 'http://pecl.php.net/package/oauth'
  url 'http://pecl.php.net/get/oauth-1.2.2.tgz'
  sha1 'bd74cd7aa150e33db20ac36f0b1459473f1ef070'
  head 'https://svn.php.net/repository/pecl/oauth/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php54' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "oauth-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/oauth.so"
    write_config_file unless build.include? "without-config-file"
  end
end
