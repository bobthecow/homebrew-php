require 'formula'

class Ezcomponents < Formula
  url 'http://ezcomponents.org/files/downloads/ezcomponents-2009.2.1-lite.tar.bz2'
  homepage 'http://ezcomponents.org'
  sha1 '2b04826602ded803b2d0a2ce929402c9ece9506c'

  def install
    (lib+'ezc').install Dir['*']
  end

  def caveats; <<-EOS.undent
    The eZ Components are installed in #{HOMEBREW_PREFIX}/lib/ezc
    Remember to update your php include_path if needed
    EOS
  end

end
