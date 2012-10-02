require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Zmq < AbstractPhp54Extension
  homepage 'http://php.zero.mq/'
  url 'https://github.com/mkoppanen/php-zmq/tarball/1.0.3'
  sha1 'ac3f28fdad28543ea3280c2a4b73f52c62deaadc'
  head 'https://github.com/mkoppanen/php-zmq.git'

  depends_on 'autoconf' => :build
  depends_on 'pkg-config'
  depends_on 'php54' unless build.include?('without-homebrew-php')

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
