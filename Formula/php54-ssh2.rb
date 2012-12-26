require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Ssh2 < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.12.tgz'
  sha1 'b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d'
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
