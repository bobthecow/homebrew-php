require 'formula'

class Php54Twig < Formula
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.9.1'
  md5 '33d5be1db521fe76504bff316d2e58fd'
  head 'git://github.com/fabpot/Twig.git', :using => :git

  depends_on 'autoconf' => :build

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    Dir.chdir 'ext/twig' do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install %w(modules/twig.so)
    end
  end

  def caveats; <<-EOS.undent
    To finish installing php54-twig:
      * Add the following lines to #{etc}/php.ini:
        [twig]
        extension="#{prefix}/twig.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the twig module.
      * If you see it, you have been successful!
    EOS
  end
end
