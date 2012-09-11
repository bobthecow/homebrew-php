require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Zmq < AbstractPhpExtension
  homepage 'http://php.zero.mq/'
  url 'https://github.com/mkoppanen/php-zmq/tarball/1.0.3'
  md5 'aca2588f94e365a16a5734f89cb633c8'
  head 'git://github.com/mkoppanen/php-zmq.git'
  version '1.0.3'

  depends_on 'autoconf' => :build
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?
  depends_on 'zmq'

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/zmq.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
