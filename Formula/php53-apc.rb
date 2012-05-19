require 'formula'

class Php53Apc < Formula
  homepage 'http://pecl.php.net/package/apc'
  url 'http://pecl.php.net/get/APC-3.1.10.tgz'
  md5 'f4a6b91903d6ba9dce89fc87bb6f26c9'
  head 'https://svn.php.net/repository/pecl/apc/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'

  def patches
    # fixes "Incorrect version tag: APC 3.1.10 shows 3.1.9"
    # https://bugs.php.net/bug.php?id=61695
    DATA unless ARGV.build_head?
  end

  def install
    Dir.chdir "APC-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-apc-pthreadmutex"
    system "make"
    prefix.install %w(modules/apc.so apc.php)
  end

  def caveats; <<-EOS.undent
    To finish installing php53-apc:
      * Add the following lines to #{etc}/php.ini:
        [apc]
        extension="#{prefix}/apc.so"
        apc.enabled=1
        apc.shm_segments=1
        apc.shm_size=64M
        apc.ttl=7200
        apc.user_ttl=7200
        apc.num_files_hint=1024
        apc.mmap_file_mask=/tmp/apc.XXXXXX
        apc.enable_cli=1
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the apc module.
      * If you see it, you have been successful!
      * You can copy "#{prefix}/apc.php" to any site to see APC's usage.
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
