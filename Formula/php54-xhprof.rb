require 'formula'

class Php54Xhprof < Formula
  homepage 'https://github.com/facebook/xhprof'
  url 'https://github.com/facebook/xhprof/tarball/270b75dddf871271fe81ed416e122bd158a883f6'
  md5 '7a33371d7aeea57a808919deade28028'
  head 'https://github.com/facebook/xhprof.git'
  version '270b75d'

  depends_on 'autoconf' => :build
  depends_on 'pcre'

  def install
    Dir.chdir "extension" do
      # See https://github.com/mxcl/homebrew/pull/5947
      ENV.universal_binary

      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/xhprof.so"
    end

    prefix.install %w(xhprof_html xhprof_lib)
  end

  def caveats; <<-EOS.undent
     To finish installing php54-xhprof:
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
