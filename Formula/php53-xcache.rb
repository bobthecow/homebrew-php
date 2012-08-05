require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Xcache < AbstractPhpExtension
  homepage 'http://xcache.lighttpd.net'
  url 'http://xcache.lighttpd.net/pub/Releases/2.0.0/xcache-2.0.0.tar.bz2'
  md5 '0e30cdff075c635e475d70a5c37d0252'

  depends_on 'autoconf' => :build
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def extension_type; "zend_extension"; end

  def install
    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary unless Hardware.is_64_bit?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/xcache.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
