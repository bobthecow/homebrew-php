require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Xdebug < AbstractPhpExtension
  homepage 'http://xdebug.org'
  url 'http://xdebug.org/files/xdebug-2.2.1.tgz'
  md5 '5e5c467e920240c20f165687d7ac3709'
  head 'https://github.com/derickr/xdebug.git'

  depends_on 'autoconf' => :build
  depends_on 'php54' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def extension_type; "zend_extension"; end

  def install
    Dir.chdir "xdebug-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make"
    prefix.install "modules/xdebug.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
