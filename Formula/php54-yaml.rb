require 'formula'

class Php54Yaml < Formula
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.0.1.tgz'
  md5 'd8a965479d919e1526dd43295783c7f7'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'libyaml'

  def install
    Dir.chdir "yaml-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/yaml.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-yaml:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/yaml.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the yaml module.
      * If you see it, you have been successful!
    EOS
  end
end
