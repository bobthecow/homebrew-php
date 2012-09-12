require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Apc < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/apc'
  url 'http://pecl.php.net/get/APC-3.1.10.tgz'
  sha1 '02c8a2f60c5b1789e7cccd9c1b421d822ca77734'
  head 'https://svn.php.net/repository/pecl/apc/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('--with-homebrew-php') && !Formula.factory('php53').installed?
  depends_on 'pcre'

  def patches
    # fixes "Incorrect version tag: APC 3.1.10 shows 3.1.9"
    # https://bugs.php.net/bug.php?id=61695
    DATA unless build.head?
  end

  def install
    Dir.chdir "APC-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-apc-pthreadmutex"
    system "make"
    prefix.install %w(modules/apc.so apc.php)
    write_config_file unless build.include? "without-config-file"
  end

  def config_file
    super + <<-EOS.undent
      apc.enabled=1
      apc.shm_segments=1
      apc.shm_size=64M
      apc.ttl=7200
      apc.user_ttl=7200
      apc.num_files_hint=1024
      apc.mmap_file_mask=/tmp/apc.XXXXXX
      apc.enable_cli=0
    EOS
  end
end

__END__
diff --git a/APC-3.1.10/php_apc.h b/APC-3.1.10/php_apc.h
index 77f66d5..aafa3b7 100644
--- a/APC-3.1.10/php_apc.h
+++ b/APC-3.1.10/php_apc.h
@@ -35,7 +35,7 @@
  #include "apc_php.h"
  #include "apc_globals.h"

-#define PHP_APC_VERSION "3.1.9"
+#define PHP_APC_VERSION "3.1.10"

  extern zend_module_entry apc_module_entry;
  #define apc_module_ptr &apc_module_entry
