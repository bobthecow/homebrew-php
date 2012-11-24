require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Redis < AbstractPhp53Extension
  homepage 'https://github.com/nicolasff/phpredis'
  url 'https://github.com/nicolasff/phpredis/tarball/2.2.2'
  sha1 '156677eab43a9d4337d3254ae4e957a6039ed861'
  head 'https://github.com/nicolasff/phpredis.git'

  def self.init
    super
    option 'with-igbinary', "Build with igbinary support"
    depends_on 'php53-igbinary' if build.include?('with-igbinary')
  end

  init

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      argument to 'va_arg' is of incomplete type 'void'
      This is fixed in HEAD, and can be removed for the next release.
      EOS
  end unless build.head?

  def install
    ENV.universal_binary if build.universal?

    args = []
    args << "--prefix=#{prefix}"
    args << phpconfig
    args << "--enable-redis-igbinary" if build.include? 'with-igbinary'

    safe_phpize
    system "./configure", *args
    system "make"
    prefix.install "modules/redis.so"
    write_config_file unless build.include? "without-config-file"
  end
end
