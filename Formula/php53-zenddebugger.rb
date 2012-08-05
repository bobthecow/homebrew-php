require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Zenddebugger < AbstractPhpExtension
  homepage 'http://www.zend.com/community/pdt/downloads'
  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.zend.com/studio_debugger/20100729/ZendDebugger-20100729-darwin9.5-x86_64.tar.gz'
    md5 'd48d51902040f62343cd4a8484d6bc62'
    version '20100729'
  else
    url 'http://downloads.zend.com/studio_debugger/2011_04_10/ZendDebugger-20110410-darwin-i386.tar.gz'
    md5 '7027cd83280abf714a5fda98cdde08d8'
    version '20110410'
  end

  skip_clean :all

  def extension_type; "zend_extension"; end

  def options
    [['--32-bit', 'Build 32-bit only.']]
  end

  def install
    prefix.install "5_3_x_comp/ZendDebugger.so"
    prefix.install "dummy.php"
  end

  def caveats; <<-EOS.undent
     To finish installing php53-zenddebugger:
       * Add the following lines to the end of #{etc}/php.ini:
         [ZendDebugger]
         zend_extension="#{prefix}/ZendDebugger.so"
         zend_debugger.allow_hosts=<host_ip_addresses>

       ** <host_ip_addresses> are the IPs of the hosts which will be allowed to initiate debug sessions
       * Restart your webserver.
       * Write a PHP page that calls "phpinfo();"
       * Load it in a browser and look for the info on the Zend Debugger module.
       * If you see it, you have been successful!
     Additional information is available at: http://static.zend.com/topics/Zend-Debugger-Installation-Guide-050211.pdf
     EOS
  end
end
