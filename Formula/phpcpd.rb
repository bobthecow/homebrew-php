require 'formula'

def php_installed?
    `which php`.length > 0
end

def php_phar_module_enabled?
    `php -m`.downcase.include? "phar"
end

class Phpcpd < Formula
  homepage 'https://github.com/sebastianbergmann/phpcpd'
  url 'http://pear.phpunit.de/get/phpcpd.phar'
  sha1 '86d59e472a424ab41bb657d41b77dc01a4868dc7'
  version '1.4.0'

  depends_on 'php53' => :recommended unless php_installed? && php_phar_module_enabled?

  def install
    libexec.install "phpcpd.phar"
    sh = libexec + "phpcpd"
    sh.write("/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/phpcpd.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end

  def test
    system 'phpcpd --version'
  end

  def caveats; <<-EOS.undent
    Verify your installation by running:
      "phpcpd --version".

    You can read more about phpcpd by running:
      "brew home phpcpd".
    EOS
  end
end
