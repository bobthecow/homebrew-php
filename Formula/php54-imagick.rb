require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Imagick < AbstractPhp54Extension
  homepage 'http://pecl.php.net/package/imagick'
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  sha1 '29b6dcd534cde6b37ebe3ee5077b71a9eed685c2'
  head 'https://svn.php.net/repository/pecl/imagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'imagemagick'
  depends_on 'php54' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "imagick-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/imagick.so"
    write_config_file unless build.include? "without-config-file"
  end
end
