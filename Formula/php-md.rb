require 'formula'
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'php-meta-requirement')
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'phar-requirement')

class PhpMd < Formula
  homepage 'http://phpmd.org/'
  url 'http://static.phpmd.org/php/1.4.0/phpmd.phar'
  sha1 'a13ab5dd6abb9691c9e844770a79e8ae6be7a43e'
  version '1.4.0'

  depends_on PhpMetaRequirement.new
  depends_on PharRequirement.new

  def install
    libexec.install "phpmd.phar"
    sh = libexec + "phpmd"
    sh.write("/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/phpmd.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end

  def test
    system 'phpmd --version'
  end

  def caveats; <<-EOS.undent
    Verify your installation by running:
      "phpmd --version".

    You can read more about phpmd by running:
      "brew home phpmd".
    EOS
  end
end
