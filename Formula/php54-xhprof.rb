require File.join(File.dirname(__FILE__), 'abstract-php-extension')
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'xhprof54-requirement')

class Php54Xhprof < AbstractPhp54Extension
  init
  homepage 'https://github.com/facebook/xhprof'
  url 'https://github.com/facebook/xhprof/tarball/270b75dddf871271fe81ed416e122bd158a883f6'
  sha1 'bcab304b002043d1b31a4e66231e4ec93573e30c'
  head 'https://github.com/facebook/xhprof.git'
  version '270b75d'

  depends_on Xhprof54Requirement.new
  depends_on 'pcre'

  def install
    Dir.chdir "extension" do
      ENV.universal_binary if build.universal?

      safe_phpize
      system "./configure", "--prefix=#{prefix}",
                            phpconfig
      system "make"
      prefix.install "modules/xhprof.so"
    end

    prefix.install %w(xhprof_html xhprof_lib)
    write_config_file unless build.include? "without-config-file"
  end
end
