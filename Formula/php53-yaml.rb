require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Yaml < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.0.1.tgz'
  md5 'd8a965479d919e1526dd43295783c7f7'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libyaml'
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "yaml-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/yaml.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
