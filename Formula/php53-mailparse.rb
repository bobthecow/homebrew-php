require 'formula'

class Php53Mailparse < Formula
  homepage 'http://pecl.php.net/package/mailparse'
  url 'http://pecl.php.net/get/mailparse-2.1.6.tgz'
  md5 '0f84e1da1d074a4915a9bcfe2319ce84'
  head 'https://svn.php.net/repository/pecl/mailparse/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'

  def install
    Dir.chdir "mailparse-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/mailparse.so"
  end

  def caveats; <<-EOS.undent
     To finish installing php53-mailparse:
       * Add the following line to #{etc}/php.ini:
         [mailparse]
         extension="#{prefix}/mailparse.so"
       * Restart your webserver.
       * Write a PHP page that calls "phpinfo();"
       * Load it in a browser and look for the info on the xhprof module.
       * If you see it, you have been successful!
     EOS
  end
end
