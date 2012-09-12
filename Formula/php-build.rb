require 'formula'

class PhpBuild < Formula
  homepage 'http://chh.github.com/php-build/'
  url 'https://github.com/CHH/php-build/zipball/v0.8.0'
  sha1 '9b747a2c7fdcd661d7f54d8e68ce71273be9e45b'
  head 'https://github.com/CHH/php-build.git'

  depends_on 'autoconf' => :build

  def install
    bin.install Dir['bin/php-build']
    share.install Dir['share/php-build']
    man1.install Dir['man/php-build.1']
  end

  def test
    system "php-build --definitions"
  end

  def caveats; <<-EOS.undent
    Tidy is enabled by default which will only work
    on 10.7. Be sure to disable or patch Tidy for
    earlier versions of OS X.
    EOS
  end
end
