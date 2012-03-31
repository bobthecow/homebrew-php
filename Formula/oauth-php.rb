require 'formula'

class OauthPhp < Formula
  homepage 'http://pecl.php.net/package/oauth'
  url 'http://pecl.php.net/get/oauth-1.2.2.tgz'
  md5 '9a9f35e45786534d8580abfffc8c273c'
  head 'https://svn.php.net/repository/pecl/oauth/trunk', :using => :svn

  depends_on 'autoconf'

  def install
    if not ARGV.build_head?
      Dir.chdir "oauth-#{version}"
    end

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/oauth.so'
  end

  def caveats; <<-EOS.undent
    To finish installing oauth-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/oauth.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the oauth module.
      * If you see it, you have been successful!
    EOS
  end
end
