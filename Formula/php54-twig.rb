require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Twig < AbstractPhp54Extension
  init
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.11.1'
  sha1 'dfac84344d7d70141e5bd3296a8c9572c1bb4086'
  head 'https://github.com/fabpot/Twig.git', :using => :git

  def install
    ENV.universal_binary if build.universal?

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
