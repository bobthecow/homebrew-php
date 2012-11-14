require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Zmq < AbstractPhp54Extension
  init
  homepage 'http://php.zero.mq/'
  url 'https://github.com/mkoppanen/php-zmq/tarball/1.0.3'
  sha1 'ac3f28fdad28543ea3280c2a4b73f52c62deaadc'
  head 'https://github.com/mkoppanen/php-zmq.git'

  depends_on 'pkg-config'

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/zmq.so"
    write_config_file unless build.include? "without-config-file"
  end
end
