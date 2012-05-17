require 'formula'

def php_installed?
    `which php`.length > 0
end

def composer_reqs?
  `curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -- --check`.include? "All settings correct"
end

class ComposerPhp < Formula
  homepage 'http://getcomposer.org'
  url 'http://getcomposer.org/download/1.0.0-alpha3/composer.phar'
  md5 '82fa6b15cc95b667d695489e39a9fceb'
  version '1.0.0-alpha3'

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
      "brew home composer-php".
    EOS
  end

end
