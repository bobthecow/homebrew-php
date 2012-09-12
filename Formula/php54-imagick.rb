require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Imagick < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  sha1 '64dd5c8ff4d43d94e65c3b35ac0b439676ecc746'
  head 'https://svn.php.net/repository/pecl/imagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'imagemagick'
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "imagick-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/imagick.so"
    write_config_file unless build.include? "without-config-file"
  end
end
