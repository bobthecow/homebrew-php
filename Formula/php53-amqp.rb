require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Amqp < AbstractPhp53Extension
  homepage 'http://pecl.php.net/package/amqp'
  url 'http://pecl.php.net/get/amqp-1.0.3.tgz'
  sha1 '90a92f9752fde0cb8e4c6525aabfa6e678bbea23'
  head 'http://svn.php.net/repository/pecl/amqp/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' unless build.include?('without-homebrew-php')
  depends_on 'rabbitmq-c'

  def install
    Dir.chdir "amqp-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/amqp.so"
    write_config_file unless build.include? "without-config-file"
  end
end
