require 'formula'

class MongoPhp < Formula
  homepage 'http://pecl.php.net/package/mongo'
  url 'http://pecl.php.net/get/mongo-1.2.10.tgz'
  md5 'e74fd1b235278a895795f19692923a16'

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "mongo-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/mongo.so"
    end
  end

  def caveats; <<-EOS.undent
    To finish installing mongo-php:
      * Add the following lines to #{etc}/php.ini:
        [mongo]
        extension="#{prefix}/mongo.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the mongo module.
      * If you see it, you have been successful!
    EOS
  end
end
