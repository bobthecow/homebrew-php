require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Libvirt < AbstractPhp53Extension
  init
  homepage 'http://libvirt.org/php'
  url 'git://libvirt.org/libvirt-php', :using => :git, :tag => 'libvirt-php-0.4.7' 
  version '0.4.7'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libvirt'

  def install
    ENV.universal_binary if build.universal?

    # autogen
    system "PATH=$PATH:/usr/local/bin ./autogen.sh"

    # safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-libvirt=#{Formula.factory('libvirt').prefix}"
    system "make"
    prefix.install 'src/libvirt-php.so' => 'libvirt.so'
    write_config_file unless build.include? "without-config-file"
  end
end
