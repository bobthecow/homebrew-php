require 'formula'

class Php54Ssh2 < Formula
  homepage 'http://pecl.php.net/package/ssh2'
  url 'http://pecl.php.net/get/ssh2-0.11.3.tgz'
  md5 'd295c966adf1352cad187604b312c687'
  head 'https://svn.php.net/repository/pecl/ssh2/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libssh2'

  def install
    Dir.chdir "ssh2-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary unless Hardware.is_64_bit?

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/ssh2.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-ssh2:
      * Add the following line to #{etc}/php.ini:
        [ssh2]
        extension="#{prefix}/ssh2.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the ssh2 module.
      * If you see it, you have been successful!
    EOS
  end
end
