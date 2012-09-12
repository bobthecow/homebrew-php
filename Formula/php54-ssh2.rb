require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Ssh2 < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.11.3.tgz'
  sha1 '8d1e4b59e1fff368c5a3dde04fc93c5361203077'
  head 'https://svn.php.net/repository/pecl/ssh2/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libssh2'
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "ssh2-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary unless Hardware.is_64_bit?

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/ssh2.so"
    write_config_file unless build.include? "without-config-file"
  end
end
