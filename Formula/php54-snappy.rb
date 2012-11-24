require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Snappy < AbstractPhp54Extension
  init
  homepage 'http://code.google.com/p/php-snappy/'
  url 'http://php-snappy.googlecode.com/files/php-snappy-0.0.2.tar.gz'
  sha1 '8537def4d9358830c26119e321a9080db1228c78'
  head 'http://php-snappy.googlecode.com/svn/trunk/', :using => :svn

  depends_on 'snappy'

  def install
    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/snappy.so"
    write_config_file unless build.include? "without-config-file"
  end
end
