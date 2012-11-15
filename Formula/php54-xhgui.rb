require File.join(File.dirname(__FILE__), 'abstract-php-extension')
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'xhgui54-requirement')

class Php54Xhgui < AbstractPhp54Extension
  init
  homepage 'https://github.com/preinheimer/xhprof'
  url 'https://github.com/preinheimer/xhprof/tarball/58ceef1a59e89eb44a932e767d04e2340521cd77'
  sha1 'bfd2e5b6e97a07c8bc17fa5f569244a6883aed7c'
  head 'https://github.com/preinheimer/xhprof.git'
  version '58ceef1'

  depends_on Xhgui54Requirement.new
  depends_on 'pcre'

  def install
    Dir.chdir "extension" do
      # See https://github.com/mxcl/homebrew/pull/5947
      ENV.universal_binary

      safe_phpize
      system "./configure", "--prefix=#{prefix}",
                            phpconfig
      system "make"
      system("cp modules/xhprof.so modules/xhgui.so")
      prefix.install "modules/xhgui.so"
    end

    prefix.install %w(xhprof_html xhprof_lib)
    write_config_file unless build.include? "without-config-file"
  end
end
