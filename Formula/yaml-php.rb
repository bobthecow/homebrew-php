require 'formula'

class YamlPhp < Formula
  homepage 'http://pecl.php.net/package/yaml'
  url 'http://pecl.php.net/get/yaml-1.0.1.tgz'
  head 'https://svn.php.net/repository/pecl/yaml/trunk', :using => :svn
  md5 'd8a965479d919e1526dd43295783c7f7'

  depends_on 'libyaml'

  def install
    if not ARGV.build_head?
      Dir.chdir "yaml-#{version}"
    end

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/yaml.so'
  end

  def caveats; <<-EOS.undent
    To finish installing yaml-php:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/yaml.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the yaml module.
      * If you see it, you have been successful!
    EOS
  end
end
