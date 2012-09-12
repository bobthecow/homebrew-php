require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Xcache < AbstractPhpExtension
  homepage 'http://xcache.lighttpd.net'
  url 'http://xcache.lighttpd.net/pub/Releases/2.0.0/xcache-2.0.0.tar.bz2'
  sha1 '8a41d0a7ec92dea96677514a5e74bf15e76c7466'

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

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
    write_config_file unless build.include? "without-config-file"
  end
end
