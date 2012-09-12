require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Inclued < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/inclued'
  url 'http://pecl.php.net/get/inclued-0.1.3.tgz'
  sha1 '3967cfa654a9bd7f0a793700030c5d28b744d48d'
  head 'https://svn.php.net/repository/pecl/inclued/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "inclued-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/inclued.so"
    write_config_file unless build.include? "without-config-file"
  end
end
