require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Mailparse < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/mailparse'
  url 'http://pecl.php.net/get/mailparse-2.1.6.tgz'
  md5 '0f84e1da1d074a4915a9bcfe2319ce84'
  head 'https://svn.php.net/repository/pecl/mailparse/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'
  depends_on 'php54' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "mailparse-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/mailparse.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
