require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Xdebug < AbstractPhpExtension
  homepage 'http://xdebug.org'
  url 'http://xdebug.org/files/xdebug-2.2.1.tgz'
  sha1 '8b4aec5f68f2193d07bf4839ee46ff547740ed7e'
  head 'https://github.com/derickr/xdebug.git'

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def extension_type; "zend_extension"; end

  def install
    Dir.chdir "xdebug-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make"
    prefix.install "modules/xdebug.so"
    write_config_file unless build.include? "without-config-file"
  end
end
