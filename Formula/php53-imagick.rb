require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Imagick < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.0.1.tgz'
  md5 'e2167713316639705202cf9b6cb1fdb1'
  head 'https://svn.php.net/repository/pecl/imagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'imagemagick'
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "imagick-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/imagick.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
