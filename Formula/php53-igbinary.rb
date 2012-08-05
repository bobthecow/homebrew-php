require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Igbinary < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  md5 '4ad53115ed7d1d452cbe50b45dcecdf2'
  head 'git://github.com/igbinary/igbinary.git', :using => :git

  def install
    Dir.chdir "igbinary-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install %w(modules/igbinary.so)
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
