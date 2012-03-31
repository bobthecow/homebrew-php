require 'formula'

class PhpVersion < Formula
  homepage 'https://github.com/wilmoore/php-version'
  url 'https://github.com/wilmoore/php-version/tarball/0.7.1'
  md5 '83bd52b6a674568db314e5f9ecb88ea3'
  head 'https://github.com/wilmoore/php-version.git'

  def install
    prefix.install Dir['*']
  end

  def caveats;
    <<-EOS.undent
      For Bash, add the following into your $HOME/.bashrc or $HOME/.bash_profile:

        ########################################################################################
        # php-version (activate default PHP version and autocompletion)
        # PHP_HOME                      => should reflect location of compiled PHP versions
        # PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
        ########################################################################################
        export PHP_HOME=$HOME/local/php/versions
        source $(brew --prefix php-version)/php-version.sh && php-version 5.4.0 >/dev/null
    EOS
  end
end
