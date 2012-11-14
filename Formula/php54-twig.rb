require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Twig < AbstractPhp54Extension
  init
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.9.2'
  sha1 '5e734f152d09df1f49de70cc27b031887c4408dd'
  head 'https://github.com/fabpot/Twig.git', :using => :git

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    Dir.chdir 'ext/twig' do
      safe_phpize
      system "./configure", "--prefix=#{prefix}",
                            phpconfig
      system "make"
      prefix.install %w(modules/twig.so)
    end
    write_config_file unless build.include? "without-config-file"
  end
end
