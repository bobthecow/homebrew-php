require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Zenddebugger < AbstractPhpExtension
  homepage 'http://www.zend.com/community/pdt/downloads'
  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://downloads.zend.com/studio_debugger/20100729/ZendDebugger-20100729-darwin9.5-x86_64.tar.gz'
    sha1 'cbdf1c712457ef64920cf0a109cf7d8563ed44c6'
    version '20100729'
  else
    url 'http://downloads.zend.com/studio_debugger/2011_04_10/ZendDebugger-20110410-darwin-i386.tar.gz'
    sha1 '89e22b0ac949fe88db014f485999e9a1af9a0810'
    version '20110410'
  end

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  skip_clean :all

  def extension_type; "zend_extension"; end

  option '32-bit', "Build 32-bit only."

  def install
    prefix.install "5_3_x_comp/ZendDebugger.so"
    prefix.install "dummy.php"
    write_config_file unless build.include? "without-config-file"
  end

  def config_file
    super + <<-EOS.undent
      zend_debugger.allow_hosts=127.0.0.1/32
      zend_debugger.allow_tunnel=
      zend_debugger.deny_hosts=
      zend_debugger.expose_remotely=always
      zend_debugger.httpd_uid=-1
      zend_debugger.max_msg_size=2097152
      zend_debugger.tunnel_max_port=65535
      zend_debugger.tunnel_min_port=1024
    EOS
  end

end
