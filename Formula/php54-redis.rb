require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Redis < AbstractPhpExtension
  homepage 'https://github.com/nicolasff/phpredis'
  url 'https://github.com/nicolasff/phpredis/tarball/2.2.0'
  sha1 '8e131f12b68eaf5d6b840277cd986f88a434b90e'
  head 'https://github.com/nicolasff/phpredis.git'

  depends_on 'autoconf' => :build
  depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      argument to 'va_arg' is of incomplete type 'void'
      This is fixed in HEAD, and can be removed for the next release.
      EOS
  end unless build.head?

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/redis.so"
    write_config_file unless build.include? "without-config-file"
  end
end
