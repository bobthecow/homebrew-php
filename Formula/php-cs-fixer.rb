require 'formula'

def php_installed?
    `which php`.length > 0
end

def php_phar_module_enabled?
    `php -m`.downcase.include? "phar"
end

class PhpCsFixer < Formula
  homepage 'http://cs.sensiolabs.org'
  url 'http://cs.sensiolabs.org/get/php-cs-fixer.phar'
  sha1 '15fd2bb68070b7b0fb2562b5fe8e8683a71e5676'
  version '0.2'

  depends_on 'php53' => :recommended unless php_installed? && php_phar_module_enabled?

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
