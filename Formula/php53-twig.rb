require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Twig < AbstractPhpExtension
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.9.2'
  md5 '2985418adf4de2543699d7e6acd1fa7b'
  head 'git://github.com/fabpot/Twig.git', :using => :git

  depends_on 'autoconf' => :build
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    Dir.chdir 'ext/twig' do
      safe_phpize
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install %w(modules/twig.so)
    end
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
