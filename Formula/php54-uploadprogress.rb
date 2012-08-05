require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Uploadprogress < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/uploadprogress'
  url 'http://pecl.php.net/get/uploadprogress-1.0.3.1.tgz'
  md5 '13fdc39d68e131f37c4e18c3f75aeeda'
  head 'https://svn.php.net/repository/pecl/uploadprogress/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'
  depends_on 'php54' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "uploadprogress-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/uploadprogress.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
