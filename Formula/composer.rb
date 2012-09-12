require 'formula'

def php_installed?
    `which php`.length > 0
end

def composer_reqs?
  `curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -- --check`.include? "All settings correct"
end

class Composer < Formula
  homepage 'http://getcomposer.org'
  url 'http://getcomposer.org/download/1.0.0-alpha5/composer.phar'
  sha1 '572615d4ccf9390f32b254fe340fb9abfa88e457'
  version '1.0.0-alpha5'

  depends_on 'php' => :recommended unless php_installed?

  def install
    unless composer_reqs?
      raise <<-EOS.undent
        Composer PHP requirements check has failed. Please run
        `curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -- --check`
        to identify and fix any issues
      EOS
    end

    libexec.install "composer.phar"
    sh = libexec + "composer"
    sh.write("/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/composer.phar $*")
    chmod 0755, sh
    bin.install_symlink sh

  end

  def test
    system 'composer --version'
  end

  def caveats; <<-EOS.undent
    Verify your installation by running:
      "composer --version".

    You can read more about composer and packagist by running:
      "brew home composer".
    EOS
  end

end
