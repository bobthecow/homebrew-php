require 'formula'

class Php53Igbinary < Formula
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  md5 '4ad53115ed7d1d452cbe50b45dcecdf2'
  head 'git://github.com/igbinary/igbinary.git', :using => :git

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "igbinary-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install %w(modules/igbinary.so)
  end

  def caveats; <<-EOS.undent
    To finish installing php53-igbinary:
      * Add the following lines to #{etc}/php.ini:
        [igbinary]
        extension="#{prefix}/igbinary.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the igbinary module.
      * If you see it, you have been successful!
    EOS
  end
end
