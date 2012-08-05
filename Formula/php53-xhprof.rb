require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Xhprof < AbstractPhpExtension
  homepage 'http://mirror.facebook.net/facebook/xhprof/doc.html'
  url 'http://pecl.php.net/get/xhprof-0.9.2.tgz'
  md5 'ae40b153d157e6369a32e2c1a59a61ec'

  depends_on 'pcre'

  def install
    Dir.chdir "xhprof-#{version}/extension" do
      # See https://github.com/mxcl/homebrew/pull/5947
      ENV.universal_binary

      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/xhprof.so"
    end

    Dir.chdir "xhprof-#{version}" do
      prefix.install %w(xhprof_html xhprof_lib)
    end
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
