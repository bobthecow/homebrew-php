require 'formula'

class Php54Oauth < Formula
  homepage 'http://pecl.php.net/package/oauth'
  url 'http://pecl.php.net/get/oauth-1.2.2.tgz'
  md5 '9a9f35e45786534d8580abfffc8c273c'
  head 'https://svn.php.net/repository/pecl/oauth/trunk', :using => :svn

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "oauth-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/oauth.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-oauth:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/oauth.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the oauth module.
      * If you see it, you have been successful!
    EOS
  end
end
