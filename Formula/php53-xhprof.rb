require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Xhprof < AbstractPhp53Extension
  homepage 'http://mirror.facebook.net/facebook/xhprof/doc.html'
  url 'http://pecl.php.net/get/xhprof-0.9.2.tgz'
  sha1 'cef6bfb3374e05c7b7445249a304e066d4fd8574'

  depends_on 'autoconf' => :build
  depends_on 'pcre'
  depends_on 'php53' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "xhprof-#{version}/extension" do
      # See https://github.com/mxcl/homebrew/pull/5947
      ENV.universal_binary

      safe_phpize
      system "./configure", "--prefix=#{prefix}",
                            phpconfig
      system "make"
      prefix.install "modules/xhprof.so"
    end

    Dir.chdir "xhprof-#{version}" do
      prefix.install %w(xhprof_html xhprof_lib)
    end
    write_config_file unless build.include? "without-config-file"
  end
end
