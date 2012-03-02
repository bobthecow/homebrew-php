require 'formula'

class Uploadprogress < Formula
  homepage 'http://pecl.php.net/package/uploadprogress'
  url 'http://pecl.php.net/get/uploadprogress-1.0.3.1.tgz'
  md5 '13fdc39d68e131f37c4e18c3f75aeeda'

  depends_on 'pcre'

  def install
    Dir.chdir "uploadprogress-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"

      prefix.install %w(modules/uploadprogress.so)
    end
  end

  def caveats; <<-EOS.undent
    To finish installing uploadprogress:
     * Add the following lines to php.ini:
        [uploadprogress]
        extension="#{prefix}/uploadprogress.so"
     * Restart your webserver
    EOS
  end
end
