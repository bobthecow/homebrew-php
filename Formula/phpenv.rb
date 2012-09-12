require 'formula'

class Phpenv < Formula
  homepage 'https://github.com/CHH/phpenv'
  head 'https://github.com/CHH/phpenv.git'

  option 'skip-install', "Do not run phpenv-install.sh"

  def install
    bin.install 'bin/phpenv-install.sh'
    man1.install 'man/phpenv-install.1'
    doc.install 'man/phpenv-install.1.html'
    system("#{bin}/phpenv-install.sh") unless build.include? 'skip-install'
  end

  def caveats;
    output = "To finish installing phpenv:\n"
    output << " * Run phpenv-install.sh\n" if build.include? 'skip-install'
    output << " * Add ~/.phpenv/bin to your $PATH\n"
    output << " * Add \"eval $(phpenv init -)\" at the end of your ~/.bashrc\n"
    output << " * Restart your shell"
    output
  end
end
