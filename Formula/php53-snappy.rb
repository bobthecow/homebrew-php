require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Snappy < AbstractPhpExtension
  homepage 'http://code.google.com/p/php-snappy/'
  url 'http://php-snappy.googlecode.com/files/php-snappy-0.0.2.tar.gz'
  sha1 '8537def4d9358830c26119e321a9080db1228c78'
  head 'http://php-snappy.googlecode.com/svn/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?
  depends_on 'snappy'

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/snappy.so"
    write_config_file unless build.include? "without-config-file"
  end
end
