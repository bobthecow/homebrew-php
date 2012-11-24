require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Ssh2 < AbstractPhp53Extension
  init
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.11.3.tgz'
  sha1 '8d1e4b59e1fff368c5a3dde04fc93c5361203077'
  head 'https://svn.php.net/repository/pecl/ssh2/trunk/', :using => :svn

  depends_on 'libssh2'

  def install
    Dir.chdir "ssh2-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/ssh2.so"
    write_config_file unless build.include? "without-config-file"
  end
end
