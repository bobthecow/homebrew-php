require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Uploadprogress < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/uploadprogress'
  url 'http://pecl.php.net/get/uploadprogress-1.0.3.1.tgz'
  sha1 '5fd50a1d5d3ee485e31e16d76b686873125e8dec'
  head 'https://svn.php.net/repository/pecl/uploadprogress/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "uploadprogress-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/uploadprogress.so"
    write_config_file unless build.include? "without-config-file"
  end
end
