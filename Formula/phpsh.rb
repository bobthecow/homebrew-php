require 'formula'

def python_installed?
  `which python`.length > 0
end

class Phpsh < Formula
  homepage 'http://www.phpsh.org/'
  url 'https://github.com/facebook/phpsh.git'
  version "1.3"

  depends_on 'python' => :recommended unless python_installed?

  def install
    system "python","setup.py", "install","--prefix=#{prefix}"
    man1.install ['src/doc/phpsh.1']
    system "rm","-rf","#{prefix}/man"
    bin.install ['src/phpsh']
  end
end
