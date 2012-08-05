require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Gearman < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/gearman'
  url 'http://pecl.php.net/get/gearman-1.0.2.tgz'
  md5 '98464746d1de660f15a25b1bc8fcbc8a'
  head 'https://svn.php.net/repository/pecl/gearman/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'gearman'
  depends_on 'php54' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def install
    Dir.chdir "gearman-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--with-gearman=#{Formula.factory('gearman').prefix}"
    system "make"
    prefix.install "modules/gearman.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
