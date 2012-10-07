require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Dbase < AbstractPhp53Extension
  homepage 'http://pecl.php.net/package/dbase/5.1.0'
  url 'http://pecl.php.net/get/dbase-5.1.0.tgz'
  sha1 'e3740fae3eba6a5d65ca928445f15d58e529201d'
  version '5.1.0'

  depends_on 'autoconf' => :build
  depends_on 'php53' unless build.include?('without-homebrew-php')

  def install
    Dir.chdir "dbase-5.1.0"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"

    system "make"
    prefix.install "modules/dbase.so"
    write_config_file unless build.include? "without-config-file"
  end
end