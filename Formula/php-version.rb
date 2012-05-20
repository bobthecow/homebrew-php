require 'formula'

class PhpVersion < Formula
  homepage  'http://wilmoore.github.com/php-version'
  url       'https://github.com/wilmoore/php-version/tarball/0.9.2'
  md5       '4fe3d8cacd589d82104d08bd6746a405'
  head      'https://github.com/wilmoore/php-version.git'

  def install
    prefix.install Dir['*']
  end

  def caveats;
    <<-EOS.undent
      Add the following script block to `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file.

      Change `5.x.x` to the version of PHP you'd like your shell to default to or remove `php-version 5.x.x >/dev/null`
      if you do not wish to have a default version of PHP loaded into your `$PATH`. The large comment block is optional:

      ########################################################################################
      # php-version (activate default PHP version and autocompletion)
      # PHP_HOME                      => should reflect location of compiled PHP versions
      # PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
      ########################################################################################
      export PHP_VERSIONS=$(dirname $(brew --prefix php))
      [ -f $(brew --prefix php-version)/php-version.sh ] &&
        source $(brew --prefix php-version)/php-version.sh && php-version 5.x.x >/dev/null
    EOS
  end
end
