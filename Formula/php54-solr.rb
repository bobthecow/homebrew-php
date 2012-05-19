require 'formula'

class Php54Solr < Formula
  homepage 'http://pecl.php.net/package/solr'
  url 'http://pecl.php.net/get/solr-1.0.2.tgz'
  md5 '1632144b462ab22b91d03e4d59704fab'
  head 'https://svn.php.net/repository/pecl/solr/trunk/', :using => :svn

  depends_on 'autoconf' => :build

  def install
    Dir.chdir "solr-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/solr.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-solr:
      * Add the following lines to #{etc}/php.ini:
        [solr]
        extension="#{prefix}/solr.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the solr module.
      * If you see it, you have been successful!
    EOS
  end
end
