require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Inclued < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/inclued'
  url 'http://pecl.php.net/get/inclued-0.1.3.tgz'
  md5 '303f6ddba800be23d0e06a7259b75a2e'
  head 'https://svn.php.net/repository/pecl/inclued/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "inclued-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/inclued.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
