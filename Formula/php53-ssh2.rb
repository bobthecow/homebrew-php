require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Ssh2 < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.11.3.tgz'
  md5 'd295c966adf1352cad187604b312c687'
  head 'https://svn.php.net/repository/pecl/ssh2/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libssh2'
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "ssh2-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary unless Hardware.is_64_bit?

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/ssh2.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
