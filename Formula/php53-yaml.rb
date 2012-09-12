require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Yaml < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.0.1.tgz'
  sha1 'bba27142b9656fecaa6835ad57e3614f2330a51c'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libyaml'
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "yaml-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/yaml.so"
    write_config_file unless build.include? "without-config-file"
  end
end
