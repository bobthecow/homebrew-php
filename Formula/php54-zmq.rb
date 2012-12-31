require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Zmq < AbstractPhp54Extension
  init
  homepage 'http://php.zero.mq/'
  url 'https://github.com/mkoppanen/php-zmq/tarball/1.0.5'
  sha1 'fae6a746bb581a8e44dbc0ba6c9d79e42bf1d361'
  head 'https://github.com/mkoppanen/php-zmq.git'

  depends_on 'pkg-config'

  def install
    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/zmq.so"
    write_config_file unless build.include? "without-config-file"
  end
end
