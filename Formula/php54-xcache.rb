require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Xcache < AbstractPhp54Extension
  init
  homepage 'http://xcache.lighttpd.net'
  url 'http://xcache.lighttpd.net/pub/Releases/2.0.0/xcache-2.0.0.tar.bz2'
  sha1 '8a41d0a7ec92dea96677514a5e74bf15e76c7466'

  def extension_type; "zend_extension"; end

  def install
    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/xcache.so"
    write_config_file unless build.include? "without-config-file"
  end
end
