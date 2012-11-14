require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Phalcon < AbstractPhp54Extension
  init
  homepage 'http://phalconphp.com/'
  url 'https://github.com/phalcon/cphalcon/tarball/v0.4.5'
  version '0.4.5'
  sha1 'e941f84eb236492507245b539bec7cdb69def14a'
  head 'git://github.com/phalcon/cphalcon.git', :using => :git

 depends_on 'pcre'

  def install
    if build.head?
      Dir.chdir "build"
    else
      Dir.chdir "release"
    end

    ENV.universal_binary

    safe_phpize
    system 'export CFLAGS="-O2 -fno-delete-null-pointer-checks"'
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--enable-phalcon"
    system "make"
    prefix.install "modules/phalcon.so"
    write_config_file unless build.include? "without-config-file"
  end
end
