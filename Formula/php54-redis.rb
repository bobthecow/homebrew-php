require 'formula'

class Php54Redis < Formula
  homepage 'https://github.com/nicolasff/phpredis'
  url 'https://github.com/nicolasff/phpredis/tarball/2.2.0'
  md5 '9a89b0aeae1906bcfdc8a80d14d62405'
  head 'https://github.com/nicolasff/phpredis.git'

  depends_on 'autoconf' => :build

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      argument to 'va_arg' is of incomplete type 'void'
      This is fixed in HEAD, and can be removed for the next release.
      EOS
  end unless ARGV.build_head?

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/redis.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-redis:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/redis.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the redis module.
      * If you see it, you have been successful!
    EOS
  end
end
