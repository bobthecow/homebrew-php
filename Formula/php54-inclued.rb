require 'formula'

class Php54Inclued < Formula
  homepage 'http://pecl.php.net/package/inclued'
  url 'http://pecl.php.net/get/inclued-0.1.3.tgz'
  md5 '303f6ddba800be23d0e06a7259b75a2e'
  head 'https://svn.php.net/repository/pecl/inclued/trunk', :using => :svn

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "inclued-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/inclued.so"
  end

  def caveats; <<-EOS.undent
   To finish installing php54-inclued:
     * Add the following lines to #{etc}/php.ini:
       extension="#{prefix}/inclued.so"
     * Restart your webserver.
     * Write a PHP page that calls "phpinfo();"
     * Load it in a browser and look for the info on the inclued module.
     * If you see it, you have been successful!
     EOS
  end
end
