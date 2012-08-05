require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Yaml < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.0.1.tgz'
  md5 'd8a965479d919e1526dd43295783c7f7'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn

  depends_on 'libyaml'

  def install
    Dir.chdir "yaml-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/yaml.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
