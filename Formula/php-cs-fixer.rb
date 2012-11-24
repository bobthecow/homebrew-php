require 'formula'
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'php-meta-requirement')
require File.join(HOMEBREW_LIBRARY, 'Taps', 'josegonzalez-php', 'Requirements', 'phar-requirement')

class PhpCsFixer < Formula
  homepage 'http://cs.sensiolabs.org'
  url 'http://cs.sensiolabs.org/get/php-cs-fixer.phar'
  sha1 'c93538d937952226e1e7184c6fc0ef8fe778df62'
  version '0.2'

  depends_on PhpMetaRequirement.new
  depends_on PharRequirement.new

  def install
    libexec.install "php-cs-fixer.phar"
    sh = libexec + "php-cs-fixer"
    sh.write("/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/php-cs-fixer.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end

  def test
    system 'php-cs-fixer --version'
  end

  def caveats; <<-EOS.undent
    Verify your installation by running:
      "php-cs-fixer --version".

    You can read more about php-cs-fixer by running:
      "brew home php-cs-fixer".
    EOS
  end
end
