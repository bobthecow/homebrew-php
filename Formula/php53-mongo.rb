require 'formula'

class Php53Mongo < Formula
  homepage 'http://pecl.php.net/package/mongo'
  url 'http://pecl.php.net/get/mongo-1.2.11.tgz'
  md5 '4a6e9d71ec266365c591284950d29167'
  head 'https://github.com/mongodb/mongo-php-driver.git'

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "mongo-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/mongo.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-mongo:
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
