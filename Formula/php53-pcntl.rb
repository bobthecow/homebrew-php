require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Pcntl < AbstractPhp53Extension
  homepage 'http://php.net/manual/en/book.pcntl.php'
  url 'http://www.php.net/get/php-5.3.17.tar.bz2/from/this/mirror'
  sha1 'd6f0192d2c1dae2921923762bde5ae356ceda5b5'
  version '5.3.17'

  depends_on 'autoconf' => :build
  depends_on 'php53' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "ext/pcntl"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/pcntl.so"
    write_config_file unless build.include? "without-config-file"
  end
end
