require 'formula'

class Php53Xhprof < Formula
  homepage 'http://mirror.facebook.net/facebook/xhprof/doc.html'
  url 'http://pecl.php.net/get/xhprof-0.9.2.tgz'
  md5 'ae40b153d157e6369a32e2c1a59a61ec'

  depends_on 'autoconf' => :build
  depends_on 'pcre'

  def install
    Dir.chdir "xhprof-#{version}/extension" do
      # See https://github.com/mxcl/homebrew/pull/5947
      ENV.universal_binary

      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/xhprof.so"
    end

    Dir.chdir "xhprof-#{version}" do
      prefix.install %w(xhprof_html xhprof_lib)
    end
  end

  def caveats; <<-EOS.undent
     To finish installing php53-xhprof:
       * Add the following line to #{etc}/php.ini:
         [xhprof]
         extension="#{prefix}/xhprof.so"
       * Restart your webserver.
       * Write a PHP page that calls "phpinfo();"
       * Load it in a browser and look for the info on the xhprof module.
       * If you see it, you have been successful!
     EOS
  end
end
