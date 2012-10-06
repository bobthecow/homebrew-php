require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Yaml < AbstractPhp53Extension
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.1.0.tgz'
  sha1 '8ab77d3e49eed6944bbb3130c054288402f484d7'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libyaml'
  depends_on 'php53' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "yaml-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/yaml.so"
    write_config_file unless build.include? "without-config-file"
  end
end
