require 'formula'

class Php54Http < Formula
  homepage 'http://pecl.php.net/package/pecl_http'
  url 'http://pecl.php.net/get/pecl_http-1.7.4.tgz'
  md5 '288bae57b89d8de4bdd7d7dc5954cf8c'
  version '1.7.4'
  head 'http://svn.php.net/repository/pecl/http/trunk/', :using => :svn

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "pecl_http-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/http.so"
  end

  def caveats; <<-EOS.undent
     To finish installing php54-http:
       * Add the following lines to #{etc}/php.ini:
         extension="#{prefix}/http.so"
       * Restart your webserver.
       * Write a PHP page that calls "phpinfo();"
       * Load it in a browser and look for the info on the http module.
       * If you see it, you have been successful!
     EOS
  end
end
