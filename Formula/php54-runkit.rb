require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Runkit < AbstractPhp54Extension
  homepage 'http://php.net/manual/en/book.runkit.php'
  url 'https://github.com/downloads/zenovich/runkit/runkit-1.0.3.tgz'
  sha1 'f0d0c8b0451666dcfdc5250abeff5622aedf3926'
  head 'https://github.com/zenovich/runkit.git'
  version '1.0.3'

  depends_on 'autoconf' => :build
  depends_on 'php54' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "runkit-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/runkit.so"
    write_config_file unless build.include? "without-config-file"
  end
end

