require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Igbinary < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  sha1 'cebe34d18dd167a40a712a6826415e3e5395ab27'
  head 'https://github.com/igbinary/igbinary.git', :using => :git

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "igbinary-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install %w(modules/igbinary.so)
    write_config_file unless build.include? "without-config-file"
  end
end
